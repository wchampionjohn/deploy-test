module VastHelper
  def valid_vast_xml(options = {})
    template = File.read(Rails.root.join('spec/support/fixtures/vast_template.xml'))
    template
      .gsub('{{MEDIA_URL}}', options[:media_url] || 'http://example.com/video.mp4')
      .gsub('{{DURATION}}', options[:duration] || '00:00:30')
      .gsub('{{WIDTH}}', options[:width]&.to_s || '640')
      .gsub('{{HEIGHT}}', options[:height]&.to_s || '480')
      .gsub('{{IMPRESSION_URL}}', options[:impression_url] || 'http://example.com/impression')
  end

  def mock_vast_response(valid: true)
    if valid
      allow_any_instance_of(VastValidator).to receive(:valid?).and_return(true)
      allow_any_instance_of(VastValidator).to receive(:errors).and_return([])
    else
      allow_any_instance_of(VastValidator).to receive(:valid?).and_return(false)
      allow_any_instance_of(VastValidator).to receive(:errors).and_return([ 'Invalid VAST format' ])
    end
  end

  def stub_vast_request(url, valid: true)
    stub_request(:get, url)
      .to_return(
        status: 200,
        body: valid ? valid_vast_xml : 'Invalid VAST',
        headers: { 'Content-Type' => 'application/xml' }
      )
  end
end

RSpec.configure do |config|
  config.include VastHelper, type: :request
end
