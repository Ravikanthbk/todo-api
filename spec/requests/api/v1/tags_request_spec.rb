require 'rails_helper'

describe "Tags API" do

  context "get /api/v1/tags" do

    # let(:tags) { create_list(:random_tag, 3) }
    it "No route match" do
      get '/api/v1/tagss'
      body = JSON.parse response.body
      
      expect(response).to have_http_status :not_found
      expect(body['status']).to eq '404'
      expect(body['code']).to eq '4'
      expect(body['title']).to eq 'Not Found'
      expect(body['details']).to eq 'No route matches'      
    end

    it "response to be successfull" do
      get '/api/v1/tags'
      expect(response).to be_successful
    end

    it "response to be successfull with Array list of tags" do
      create_list(:random_tag, 3)
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/tags', headers: headers

      tags = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response).to have_http_status :ok
      expect(Tag.all.size).to eq(3)
      tags.first.each do |tag|
        expect(tag).to have_key(:title)
        expect(tag[:title]).to be_a(String)
      end
    end

  end

  context "post /api/v1/tags" do

    it "no route match" do
      post '/api/v1/tagss'
      body = JSON.parse response.body
      
      expect(response).to have_http_status :not_found
      expect(body['status']).to eq '404'
      expect(body['code']).to eq '4'
      expect(body['title']).to eq 'Not Found'
      expect(body['details']).to eq 'No route matches'      
    end

    it "validate blank params" do
      tag_params = {}
  
      post "/api/v1/tags", {}
      body = JSON.parse response.body
  
      expect(response).to have_http_status '400'
      expect(body['status']).to eq '400'
      expect(body['code']).to eq '2'
      expect(body['title']).to eq 'Bad Request'
      expect(body['details']).to eq "param is missing or the value is empty: tag"
    end  

    it "validate title can not be blank" do
      tag_params = {
                  title: ""
                }

      headers = {"CONTENT_TYPE" => "application/json"}          
      post '/api/v1/tags', headers: headers, params: JSON.generate(tag: tag_params)
      body = JSON.parse response.body
  
      expect(response).to have_http_status '422'
      expect(body['status']).to eq '422'
      expect(body['code']).to eq '6'
      expect(body['title']).to eq 'Unprocessable Entity'
      expect(body['details']).to eq "Title can't be blank"
    end

    it "validate title should be unique" do
      create(:tag)
      tag_params = {
                  title: "Home"
                }

      headers = {"CONTENT_TYPE" => "application/json"}          
      post '/api/v1/tags', headers: headers, params: JSON.generate(tag: tag_params)
      body = JSON.parse response.body      
  
      expect(response).to have_http_status '422'
      expect(body['status']).to eq '422'
      expect(body['code']).to eq '6'
      expect(body['title']).to eq 'Unprocessable Entity'
      expect(body['details']).to eq "Title has already been taken"
    end

    it "successfully should create a tag" do
      tag_params = {
                  title: "Urgent"
                }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/tags', headers: headers, params: JSON.generate(tag: tag_params)
      body = JSON.parse response.body
  
      expect(response).to have_http_status :created
      expect(body['id']).to eq 1
      expect(body['title']).to eq 'Urgent'
      expect(body.keys.include?('created_at')).to be(true)
      expect(body.keys.include?('updated_at')).to be(true)      
    end

  end

  context "put /api/v1/tags" do

    it "no route match" do
      put '/api/v1/tagss'
      body = JSON.parse response.body
      
      expect(response).to have_http_status :not_found
      expect(body['status']).to eq '404'
      expect(body['code']).to eq '4'
      expect(body['title']).to eq 'Not Found'
      expect(body['details']).to eq 'No route matches'      
    end

    let(:tag) { create(:tag) }
    it "validate blank params" do
      tag_params = {}
      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/tags/#{tag.id}", headers: headers, params: JSON.generate(tag: tag_params)
      body = JSON.parse response.body
  
      expect(response).to have_http_status '400'
      expect(body['status']).to eq '400'
      expect(body['code']).to eq '2'
      expect(body['title']).to eq 'Bad Request'
      expect(body['details']).to eq "param is missing or the value is empty: tag"
    end  

    it "validate title can not be blank" do
      tag_params = {
                  title: ""
                }

      headers = {"CONTENT_TYPE" => "application/json"}          
      put "/api/v1/tags/#{tag.id}", headers: headers, params: JSON.generate(tag: tag_params)
      body = JSON.parse response.body
  
      expect(response).to have_http_status '422'
      expect(body['status']).to eq '422'
      expect(body['code']).to eq '6'
      expect(body['title']).to eq 'Unprocessable Entity'
      expect(body['details']).to eq "Title can't be blank"
    end

    it "validate title should be unique" do
      create(:tag, {title: 'Urgent'})      
      tag_params = {
                  title: "Urgent"
                }
      headers = {"CONTENT_TYPE" => "application/json"}          

      put "/api/v1/tags/#{tag.id}", headers: headers, params: JSON.generate(tag: tag_params)
      body = JSON.parse response.body      
      
      expect(response).to have_http_status '422'
      expect(body['status']).to eq '422'
      expect(body['code']).to eq '6'
      expect(body['title']).to eq 'Unprocessable Entity'
      expect(body['details']).to eq "Title has already been taken"
    end

    it "Tag record not found with id" do
      tag_params = {
                  title: "Urgent"
                }
      headers = {"CONTENT_TYPE" => "application/json"}          

      put "/api/v1/tags/101", headers: headers, params: JSON.generate(tag: tag_params)
      body = JSON.parse response.body      
      
      expect(response).to have_http_status '404'
      expect(body['status']).to eq '404'
      expect(body['code']).to eq '3'
      expect(body['title']).to eq 'Not Found'
      expect(body['details']).to eq "Couldn't find Tag with 'id'=101"
    end

    it "successfully should update a tag" do
      tag_params = {
                  title: "Urgent"
                }

      headers = {"CONTENT_TYPE" => "application/json"}
      put "/api/v1/tags/#{tag.id}", headers: headers, params: JSON.generate(tag: tag_params)
      body = JSON.parse response.body
  
      expect(response).to have_http_status :ok
      expect(body['id']).to eq 1
      expect(body['title']).to eq 'Urgent'
      expect(body.keys.include?('created_at')).to be(true)
      expect(body.keys.include?('updated_at')).to be(true)      
    end

  end

  context "get /api/v1/tags (final list)" do

    it "response to be successfull with Array list of tags" do
      create(:tag, {title: 'Home'})
      create(:tag, {title: 'Today'})
      create(:tag, {title: 'Work'})
      create(:tag, {title: 'Very Urgent'})
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/tags', headers: headers
      body = JSON.parse response.body

      expect(response).to have_http_status :ok
      expect(body.first.map{|x| x["title"]}).to eq ["Home", "Today", "Work", "Very Urgent"]
    end

  end

  context "get /api/v1/tags (pagination)" do
    # let(:tags) { create_list(:random_tag, 30) }
    it "pagination first page" do
      create_list(:random_tag, 30)
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/tags', headers: headers
      body = JSON.parse response.body

      expect(response).to have_http_status :ok
      expect(body.last["current_page"]).to eq 1
      expect(body.last["next_page"]).to eq 2
      expect(body.last["prev_page"]).to be_nil
      expect(body.last["last_page"]).to eq 3
      expect(body.last["total_pages"]).to eq 3
      expect(body.last["offset"]).to eq 0
      expect(body.last["total_count"]).to eq 30
    end

    it "pagination second page" do
      create_list(:random_tag, 30)
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/tags?page=2', headers: headers
      body = JSON.parse response.body
      
      expect(response).to have_http_status :ok
      expect(body.last["current_page"]).to eq 2
      expect(body.last["next_page"]).to eq 3
      expect(body.last["prev_page"]).to eq 1
      expect(body.last["last_page"]).to eq 3
      expect(body.last["total_pages"]).to eq 3
      expect(body.last["offset"]).to eq 10
      expect(body.last["total_count"]).to eq 30
    end

    it "pagination handle error if no page" do
      create_list(:random_tag, 8)
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/tags?page=2', headers: headers
      body = JSON.parse response.body

      expect(response).to have_http_status 500
      expect(body['status']).to eq '500'
      expect(body['code']).to eq '7'
      expect(body['title']).to eq 'Internal server error'
      expect(body['details']).to eq "expected :page in 1..1; got 2"
    end

  end

end