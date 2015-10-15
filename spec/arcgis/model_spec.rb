require File.dirname(__FILE__) + '/../spec_helper.rb'

RSpec.describe Arcgis::Model do
  context "adding an item" do
    before :all do
      @username = ArcConfig.config["online"]["username"]
      @online = Arcgis::Connection.new(
        host: ArcConfig.config["online"]["host"],
        username: ArcConfig.config["online"]["username"],
        password: ArcConfig.config["online"]["password"])
    end


    describe "of a CSV" do
      before :all do
        existing = @online.search(q: "arcgis-rb")
        existing["results"].map{|e| e["id"]}.each{|id| @online.item(id).delete}

        @response = @online.item.create(
                         :title => "arcgis-rb gem test",
                         :type => "CSV",
                         :file => File.open(File.dirname(__FILE__) + "/../data/gas_data.csv"),
                         :tags  => %w{test gas}.join(","))
        @id = @response["id"]
        i = @online.item(@id)
        @analyze_response = @online.feature.analyze(itemid: @id, type: "CSV")
        @item = i.fetch
      end

      context "with analysis" do
        it "should have publishParameters" do
          expect(@analyze_response["publishParameters"]["type"]).to eq("csv")
        end

        it "should have fields" do
          expect(@analyze_response["publishParameters"]["layerInfo"]["fields"].length).to eq(6)
        end

        describe "publishing" do
          before :all do
            pub_params = @analyze_response["publishParameters"].merge("name" => "feature#{@id}")
            @publish_response = @online.user.publish_item(
              itemId: @id,
              title: "arcgisrbtest2",
              filetype: "Feature Service",
              tags: "arcgisrbtest",
              publishParameters: pub_params.to_json)
          end

          it "should be successful" do
            expect(@publish_response.include?("services")).to eq(true)
          end

          it "should have a serviceUrl" do
            expect(@publish_response["services"].first["serviceurl"].nil?).to eq(false)
          end

          it "should have a size" do
            expect(@publish_response["services"].first["size"]).to eq(3116)
          end

          it "should have a jobId" do
            expect(@publish_response["services"].first["jobId"].nil?).to eq(false)
          end

          it "should have a serviceItemId" do
            expect(@publish_response["services"].first["serviceItemId"].nil?).to eq(false)
          end

          after :all do
            response = @online.item(@publish_response["services"].first["serviceItemId"]).delete
            expect(response["success"]).to eq(true)
          end
        end
      end

      it "should be an item" do
        expect(@item["id"]).to eq(@id)
      end

      it "should have tags" do
        expect(@item["tags"]).to eq(%w{test gas})
      end

      it "should have title" do
        expect(@item["title"]).to eq("arcgis-rb gem test")
      end

      it "should have type" do
        expect(@item["type"]).to eq("CSV")
      end

      it "should have description" do
        expect(@item["description"]).to eq(nil)
      end

      it "should have blank rating" do
        expect(@item["avgRating"]).to eq(0)
      end

      it "should have no ratings" do
        expect(@item["numRatings"]).to eq(0)
      end

      it "should have no comments" do
        expect(@item["numComments"]).to eq(0)
      end

      it "should have owner" do
        expect(@item["owner"]).to eq(@username)
      end

      after :all do
        response = @online.item(@item["id"]).delete
        expect(response["success"]).to eq(true)
      end
    end
  end
end
