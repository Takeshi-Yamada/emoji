module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
      when :notice then "bg-green-500"
      when :alert  then "bg-red-500"
      when :error  then "bg-yellow-500"
      else "bg-gray-500"
    end
  end

  def default_meta_tags
  {
    site: "🧩Emoji Riddle",
    title: "🧩Emoji Riddle",
    reverse: true,
    charset: "utf-8",
    description: "",
    keywords: "絵文字, クイズ, Emoji Riddle",
    og: {
      site_name: :site,
      title: :title,
      description: :description,
      type: "website",
      url: root_url,
      image: image_url("banana_fortune.jpg"),
      locale: "ja-JP"
    },
    twitter: {
      card: "summary_large_image",
      image: image_url("banana_fortune.jpg")
    }
  }
  end
end
