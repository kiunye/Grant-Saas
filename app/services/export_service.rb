class ExportService
  attr_reader :document

  def initialize(document)
    @document = document
  end

  # Export to PDF using wicked_pdf
  def to_pdf
    begin
      html_content = format_for_export
      
      pdf = WickedPdf.new.pdf_from_string(
        html_content,
        page_size: 'A4',
        margin: { top: 20, bottom: 20, left: 20, right: 20 }
      )

      {
        success: true,
        file: pdf
      }
    rescue => e
      {
        success: false,
        error: e.message
      }
    end
  end

  # Export to DOCX
  def to_docx
    begin
      require 'docx'
      
      doc = Docx::Document.new
      
      # Add title
      doc.p document.title do
        bold
        font_size 24
      end
      
      doc.p '' # Blank line
      
      # Add content paragraphs
      document.content.split("\n\n").each do |paragraph|
        doc.p paragraph.strip unless paragraph.strip.empty?
      end
      
      # Save to StringIO
      file = StringIO.new
      doc.save(file)
      file.rewind

      {
        success: true,
        file: file.read
      }
    rescue => e
      {
        success: false,
        error: e.message
      }
    end
  end

  private

  def format_for_export
    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <style>
            body {
              font-family: 'Times New Roman', serif;
              font-size: 12pt;
              line-height: 1.6;
              color: #333;
              max-width: 800px;
              margin: 0 auto;
            }
            h1 {
              font-size: 24pt;
              margin-bottom: 20px;
              text-align: center;
            }
            p {
              text-align: justify;
              margin-bottom: 12pt;
            }
          </style>
        </head>
        <body>
          <h1>#{document.title}</h1>
          #{format_content}
        </body>
      </html>
    HTML
  end

  def format_content
    document.content.split("\n\n").map { |para| "<p>#{para}</p>" }.join("\n")
  end
end
