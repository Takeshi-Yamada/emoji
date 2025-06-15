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
    site: "🧩Emoji Link",
    title: "🧩Emoji Link",
    reverse: true,
    charset: "utf-8",
    description: "",
    keywords: "絵文字, クイズ, Emoji Link",
    og: {
      site_name: :site,
      title: :title,
      description: :description,
      type: "website",
      url: root_url,
      image: image_url("icon-emoji1.png"),
      locale: "ja-JP"
    },
    twitter: {
      card: "summary_large_image",
      image: image_url("icon-emoji1.png")
    }
  }
  end
end
