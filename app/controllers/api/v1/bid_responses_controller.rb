# frozen_string_literal: true

class Api::V1::BidResponsesController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access only: :create

  def create
    bid_response = params[:is_video] ? vast_response : banner_response

    render json: bid_response
  end

private

  def vast_response
    xml = <<~XML
      <?xml version="1.0" encoding="UTF-8"?>
      <VAST version="4.0">
        <Ad id="ad123456">
          <InLine>
            <AdSystem>AdServer</AdSystem>
            <AdTitle><![CDATA[DOOH Video Ad]]></AdTitle>
            <Error><![CDATA[https://adserver.com/event/error]]></Error>
            <Impression><![CDATA[https://adserver.com/event/impression]]></Impression>
            <Creatives>
              <Creative id="creative789">
                <Linear>
                  <Duration>00:00:15</Duration>
                  <MediaFiles>
                    <MediaFile delivery="progressive" bitrate="8000" width="1920" height="1080" type="video/mp4" scalable="true" maintainAspectRatio="true">
                      <![CDATA[https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4]]>
                    </MediaFile>
                  </MediaFiles>
                </Linear>
              </Creative>
            </Creatives>
          </InLine>
        </Ad>
      </VAST>
    XML

    {
      id: "1234567890",
      bidid: "162059897743978051070",
      cur: "USD",
      seatbid: [
        {
          seat: "512",
          bid: [
            {
              id: "1",
              impid: "102",
              price: 10.50,
              nurl: "https://adserver.com/winnotice?impid=102&bidid=abc1123",
              burl: "https://adserver.com/billingnotice?impid=102&bidid=abc1123&price=${AUCTION_PRICE}&multiplier=${AUCTION_MULTIPLIER}",
              adm: xml,
              adomain: ["example-advertiser.com"],
              cid: "campaign123",
              crid: "creative789",
              attr: [1, 2, 3, 7, 12],
              w: 1920,
              h: 1080,
              cat: ["IAB2"]
            }
          ]
        }
      ]
    }
  end

  def banner_response
    {
      id: "1234567890",
      bidid: "162059897743978051070",
      cur: "GBP",
      seatbid: [
        {
          seat: "512",
          bid: [
            {
              id: "1",
              impid: "102",
              price: 9.43,
              banner: {
                img: "https://picsum.photos/1920/1080?image=1080",
                burl: "http://adserver.com/billingnotice?impid=102& bidid=abc1123&price=${AUCTION_PRICE}&multiplier=${AUCTION_MULTIPLIER}",
                adomain: [
                  "advertiserdomain.com"
                ],
                cid: "campaign111",
                crid: "creative112",
                attr: [
                  1,
                  2,
                  3,
                  4,
                  5,
                  6,
                  7,
                  12
                ],
                w: 1080,
                h: 1920,
                cat: [
                  "IAB1"
                ]
              }
            }
          ]
        }
      ]
    }
  end
end
