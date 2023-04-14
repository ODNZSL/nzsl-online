# frozen_string_literal: true

class SignSearchService
  SEARCH_SQL = <<-SQL.squish
  WITH sign_search(id, rank_precedence, rank_order, row_num) AS
    (SELECT rs1.id,
            rs1.rank_precedence,
            rs1.rank_order,
            ROW_NUMBER() OVER (PARTITION BY rs1.id
                              ORDER BY rs1.rank_precedence ASC) AS row_num
    FROM
      (SELECT words.id,
              1 AS rank_precedence,
              RANK() OVER (ORDER BY words.gloss) AS rank_order
        FROM words
        WHERE words.gloss_normalized = :term
        UNION SELECT words.id,
                    2 AS rank_precedence,
                    RANK() OVER (ORDER BY words.gloss_normalized) AS rank_order
        FROM words
        WHERE ' ' || LOWER(words.gloss_normalized) || ' ' GLOB LOWER(:glob_term)
        UNION SELECT words.id,
                    3 AS rank_precedence,
                    RANK() OVER (ORDER BY words.minor_normalized) AS rank_order
        FROM words
        WHERE words.minor_normalized = :term
        UNION SELECT words.id,
                    4 AS rank_precedence,
                    RANK() OVER (ORDER BY words.minor_normalized) AS rank_order
        FROM words
        WHERE LOWER(' ' || words.minor_normalized || ' ') GLOB LOWER(:glob_term)
        UNION SELECT words.id,
                    5 AS rank_precedence,
                    RANK() OVER (ORDER BY words.maori_normalized) AS rank_order
        FROM words
        WHERE words.maori_normalized = :term
        UNION SELECT words.id,
                    6 AS rank_precedence,
                    RANK() OVER (ORDER BY words.maori_normalized) AS rank_order
        FROM words
        WHERE LOWER(' ' || words.maori_normalized || ' ') GLOB LOWER(:glob_term)) AS rs1)
  SELECT *
  FROM sign_search
  WHERE sign_search.row_num = 1
  SQL

  def initialize(query, relation: Signbank::Sign)
    @relation = relation
    @query = query
  end

  # Escape glob characters, to avoid influencing the search
  # we perform in ways we don't support
  def glob_escape(term)
    term.gsub(/[*?{}\[\]\\]/, '\\\\\\&')
  end

  def keyword_search_args
    term = @query[:s].first
    unaccented_term = ActiveSupport::Inflector.transliterate(term)

    { term: unaccented_term,
      # Match a whole word in any position in the string, so long as it has
      # leading or trailing whitespace or comma.
      # We wrap glosses with space characters to make sure words at the beginning
      # or end of the gloss match.
      glob_term: "*[ ,]#{glob_escape(unaccented_term)}[ ,]*" }
  end

  def keyword_search(relation)
    relation.joins(
      "INNER JOIN (#{Signbank::Sign.sanitize_sql_array([SEARCH_SQL, keyword_search_args])}) search_results
      ON search_results.id=#{Signbank::Sign.table_name}.#{Signbank::Sign.primary_key}"
    )
  end

  def handshape_search(relation)
    handshape_group_ids = @query[:hs].select { |hs_id| hs_id.split('.').size < 3 }
    handshape_ids = @query[:hs] - handshape_group_ids
    handshape_group_ids_clause = handshape_group_ids.map do |hs_id|
      Signbank::Sign.sanitize_sql_array(['words.handshape LIKE ?', "#{hs_id}.%"])
    end.join(' OR ')

    handshape_ids_clause = (handshape_ids.any? && Signbank::Sign.sanitize_sql_array(['words.handshape IN (?)',
                                                                                     handshape_ids])) || nil
    relation.where([handshape_group_ids_clause, handshape_ids_clause].compact_blank.join(' OR '))
  end

  def location_search(relation)
    # Location groups - this is technically a group ID, but we don't have such
    # a thing in Signbank. Instead, we look for locations that start with the
    # given location group, then extract the ID number and use these to search by
    # location identifier.
    location_groups = @query[:lg] || []
    location_ids = @query[:l] || []
    location_ids += location_groups.flat_map do |lg_id|
      Signbank::SignMenu.locations.flatten.map do |location_identifier|
        next unless location_identifier.starts_with?("#{lg_id}.")

        location_identifier.match(/\A\d{1}\.(\d{1,2})\./)[1]
      end.compact
    end

    return relation if location_ids.empty?

    # We now have a collection of location IDs across groups and direct locations,
    # so we can do a OR LIKE like we do for handshapes. The location identifier from
    # Signbank is a zero-padded, two-digit string with a dash in front of the location name
    location_ids_clause = location_ids.map do |loc_id|
      Signbank::Sign.sanitize_sql_array(['words.location_identifier LIKE ?', "#{loc_id.rjust(2, '0')} - %"])
    end.join(' OR ')

    relation.where(location_ids_clause)
  end

  def topic_search(relation)
    @query[:tag] = Array.wrap(@query[:tag])
    relation.includes(:topics).where(topics: { name: @query[:tag] })
  end

  def usage_search(relation)
    relation.where(usage: @query[:usage])
  end

  def order_results(relation)
    return relation.order(gloss_normalized: :asc, variant_number: :asc) if @query[:s].blank?

    relation.order(rank_precedence: :asc, variant_number: :asc)
  end

  def results
    @relation = keyword_search(@relation) if @query[:s]&.any?
    @relation = handshape_search(@relation) if @query[:hs]&.any?
    @relation = topic_search(@relation) if @query[:tag]&.any?
    @relation = usage_search(@relation) if @query[:usage]&.any?
    @relation = location_search(@relation)
    @relation = order_results(@relation)

    @relation.group(:first,:id)
  end
end
