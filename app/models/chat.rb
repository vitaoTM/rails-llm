class Chat < ApplicationRecord
  belongs_to :user
  attr_accessor :message

  def message=(message)
    messages = [
      { 'role' => 'system', 'content' => message }
    ]
    q_and_a.each do |question, answer|
      messages << { 'role' => 'user', 'content' => question }
      messages << { 'role' => 'assistant', 'content' => answer }
    end
    # respose_raw = client.chat(
    #   parameters: {
    #     model: 'gtp-3.5-turbo'
    #     messages:,
    #     tremperature: 0.7,
    #     max_tokens: 500,
    #     top_p: 1,
    #     frequency_penalty: 0.0,
    #     presence_penalty: 0.6
    #   }
    # )

    # Rails.logger.debug response_raw
    #
    # self.q_and_a << [message, respose.choises[0].message.content]
  end

  private
  def client
    #OpenAI::Clien.new # need to setup .env file with API key
  end
end
