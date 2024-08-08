class Chat < ApplicationRecord
  belongs_to :user

  # attr_accessor :message
  has_many :messages, dependent: :destroy

  def message=(message)
    self.history = { 'prompt' => message, 'history' => [] } if history.blank?

    messages = [
      { 'role' => 'system', 'content' => history['prompt'] }
    ]

    q_and_a.each do |question, answer|
      messages << { 'role' => 'user', 'content' => question }
      messages << { 'role' => 'assistant', 'content' => answer }
    end
    messages << { 'role' => 'user', 'content' => message } if messages.size > 1

    respose_raw = client.chat(
      parameters: {
        model: 'gtp-3.5-turbo',
        messages:,
        tremperature: 0.7,
        max_tokens: 500,
        top_p: 1,
        frequency_penalty: 0.0,
        presence_penalty: 0.6
      }
    )

    self.history['history'] << respose_raw

    Rails.logger.debug response_raw
    respose = JSON.parse(respose_raw.to_json, object_class: OpenStruct)

    self.q_and_a << [message, respose.choises[0].message.content]
  end

  private

  def client
    OpenAI::Client.new # need to setup .env file with API key
  end
end
