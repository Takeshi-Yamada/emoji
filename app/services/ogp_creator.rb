class OgpCreator
  require "cairo"
  require "pango"
  require "cloudinary"
  # テストなら実行しない
  return if Rails.env.test?

  WIDTH = 1200
  HEIGHT = 630
  BACKGROUND_PATH = Rails.root.join("app/assets/images/emoji_ogp.png")
  TMP_DIR = Rails.root.join("tmp/ogp_images")
  PUBLIC_DIR = Rails.root.join("public/ogp_images")

  def self.generate(question)
    FileUtils.mkdir_p(TMP_DIR) unless Dir.exist?(TMP_DIR)
    FileUtils.mkdir_p(PUBLIC_DIR) unless Dir.exist?(PUBLIC_DIR)

    filename = "question_#{question.id}.png"
    tmp_path = TMP_DIR.join(filename)
    public_path = PUBLIC_DIR.join(filename)

    surface = Cairo::ImageSurface.from_png(BACKGROUND_PATH.to_s)
    context = Cairo::Context.new(surface)

    layout = context.create_pango_layout
    layout.text = question.content
    layout.alignment = Pango::Alignment::CENTER

    font_desc = Pango::FontDescription.new("Noto Color Emoji")
    font_desc.set_size(90 * Pango::SCALE)
    layout.font_description = font_desc

    ink_rect, logical_rect = layout.extents
    x = (WIDTH - logical_rect.width / Pango::SCALE) / 2
    y = (HEIGHT - logical_rect.height / Pango::SCALE) / 2

    context.move_to(x, y)
    context.set_source_rgb(0, 0, 0)
    context.show_pango_layout(layout)

    # PNG保存（tmp→cloudinary）
    surface.write_to_png(tmp_path.to_s)
    upload_result = Cloudinary::Uploader.upload(
      tmp_path.to_s,
      public_id: "ogp_images/question_#{question.id}",
      overwrite: true,
      resource_type: "image"
    )
  end
end
