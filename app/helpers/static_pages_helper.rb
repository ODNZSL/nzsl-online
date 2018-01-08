module StaticPagesHelper
  def alphabet_listing
    %w[A B_open B_closed C_half C_full D E F G H I J K L M N O P_open P_closed Q R S T U V W X Y Z]
  end

  def link_sign(name, id)
    return link_to name, sign_path(id) if Sign.find(id: id)
    name
  end
end
