require 'rails_helper'

RSpec.describe SignPaginationService do
  describe '#pagination_links_html' do
    let(:valid_query) { { 'tag' => ['6'] } }

    it 'generates expected output (showing page 1 of 10 results)' do
      subject = SignPaginationService.new(current_page_number: 1, total_num_results: 10, search_query: valid_query)
      result = subject.pagination_links_html
      expected = <<~EO_EXPECTED
        <li><span class="a">previous</span></li>
        <li><span class="current a">1</span></li>
        <li><span class="a">next</span></li>
      EO_EXPECTED
                 .strip
      expect(result).to eq(expected)
    end

    it 'generates expected output (showing page 2 of 100 results)' do
      subject = SignPaginationService.new(current_page_number: 2, total_num_results: 100, search_query: valid_query)
      result = subject.pagination_links_html
      expected = <<~EO_EXPECTED
        <li><a href="/signs/search?p=1&amp;tag=6"><span>previous</span></a></li>
        <li><a href="/signs/search?p=1&amp;tag=6"><span>1</span></a></li>
        <li><span class="current a">2</span></li>
        <li><a href="/signs/search?p=3&amp;tag=6"><span>3</span></a></li>
        <li><a href="/signs/search?p=4&amp;tag=6"><span>4</span></a></li>
        <li><a href="/signs/search?p=5&amp;tag=6"><span>5</span></a></li>
        <li><a href="/signs/search?p=3&amp;tag=6"><span>next</span></a></li>
      EO_EXPECTED
                 .strip
      expect(result).to eq(expected)
    end

    it 'generates expected output (showing page 1 of 1000 results)' do
      subject = SignPaginationService.new(current_page_number: 1, total_num_results: 1000, search_query: valid_query)
      result = subject.pagination_links_html
      expected = <<~EO_EXPECTED
        <li><span class="a">previous</span></li>
        <li><span class="current a">1</span></li>
        <li><a href="/signs/search?p=2&amp;tag=6"><span>2</span></a></li>
        <li><a href="/signs/search?p=3&amp;tag=6"><span>3</span></a></li>
        <li><a href="/signs/search?p=4&amp;tag=6"><span>4</span></a></li>
        <li><a href="/signs/search?p=5&amp;tag=6"><span>5</span></a></li>
        <li><span class="a">...</span></li>
        <li><a href="/signs/search?p=42&amp;tag=6"><span>42</span></a></li>
        <li><a href="/signs/search?p=2&amp;tag=6"><span>next</span></a></li>
      EO_EXPECTED
                 .strip
      expect(result).to eq(expected)
    end

    it 'generates expected output (showing page 3 of 1000 results)' do
      subject = SignPaginationService.new(current_page_number: 3, total_num_results: 1000, search_query: valid_query)
      result = subject.pagination_links_html
      expected = <<~EO_EXPECTED
        <li><a href="/signs/search?p=2&amp;tag=6"><span>previous</span></a></li>
        <li><a href="/signs/search?p=1&amp;tag=6"><span>1</span></a></li>
        <li><a href="/signs/search?p=2&amp;tag=6"><span>2</span></a></li>
        <li><span class="current a">3</span></li>
        <li><a href="/signs/search?p=4&amp;tag=6"><span>4</span></a></li>
        <li><a href="/signs/search?p=5&amp;tag=6"><span>5</span></a></li>
        <li><span class="a">...</span></li>
        <li><a href="/signs/search?p=42&amp;tag=6"><span>42</span></a></li>
        <li><a href="/signs/search?p=4&amp;tag=6"><span>next</span></a></li>
      EO_EXPECTED
                 .strip
      expect(result).to eq(expected)
    end

    it 'generates expected output (showing page 40 of 1000 results)' do
      subject = SignPaginationService.new(current_page_number: 40, total_num_results: 1000, search_query: valid_query)
      result = subject.pagination_links_html
      expected = <<~EO_EXPECTED
        <li><a href="/signs/search?p=39&amp;tag=6"><span>previous</span></a></li>
        <li><a href="/signs/search?p=1&amp;tag=6"><span>1</span></a></li>
        <li><span class="a">...</span></li>
        <li><a href="/signs/search?p=38&amp;tag=6"><span>38</span></a></li>
        <li><a href="/signs/search?p=39&amp;tag=6"><span>39</span></a></li>
        <li><span class="current a">40</span></li>
        <li><a href="/signs/search?p=41&amp;tag=6"><span>41</span></a></li>
        <li><a href="/signs/search?p=42&amp;tag=6"><span>42</span></a></li>
        <li><a href="/signs/search?p=41&amp;tag=6"><span>next</span></a></li>
      EO_EXPECTED
                 .strip
      expect(result).to eq(expected)
    end
  end
end
