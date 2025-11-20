class OpenaiService
  attr_reader :form_data

  def initialize(form_data)
    @form_data = form_data
    @client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
  end

  def generate_grant_document
    begin
      prompt = build_prompt
      
      response = @client.chat(
        parameters: {
          model: 'gpt-4',
          messages: [
            { role: 'system', content: system_message },
            { role: 'user', content: prompt }
          ],
          temperature: 0.7,
          max_tokens: 3000
        }
      )

      content = response.dig('choices', 0, 'message', 'content')
      
      {
        success: true,
        content: content
      }
    rescue => e
      {
        success: false,
        error: e.message
      }
    end
  end

  private

  def system_message
    <<~MESSAGE
      You are an expert grant writer. Your task is to create professional, compelling grant proposals 
      based on the information provided. The proposals should be well-structured, persuasive, and 
      follow best practices in grant writing. Include clear sections for:
      - Executive Summary
      - Project Description
      - Needs Statement
      - Goals and Objectives
      - Activities and Timeline
      - Expected Outcomes
      - Budget Overview (if applicable)
      
      Format the output in a professional, ready-to-submit format.
    MESSAGE
  end

  def build_prompt
    <<~PROMPT
      Please create a comprehensive grant proposal based on the following information:

      PROJECT INFORMATION:
      #{format_section(form_data[:step1])}

      NEEDS AND OBJECTIVES:
      #{format_section(form_data[:step2])}

      ACTIVITIES AND OUTCOMES:
      #{format_section(form_data[:step3])}

      Please generate a complete, professional grant proposal that incorporates all this information.
    PROMPT
  end

  def format_section(data)
    return '' unless data

    data.map { |key, value| "#{key.to_s.humanize}: #{value}" }.join("\n")
  end
end
