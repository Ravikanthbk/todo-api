require 'rails_helper'

describe "Tasks API" do

  context "get /api/v1/tasks" do

    it "No route match" do
      get '/api/v1/taskss'
      body = JSON.parse response.body
      
      expect(response).to have_http_status :not_found
      expect(body['status']).to eq '404'
      expect(body['code']).to eq '4'
      expect(body['title']).to eq 'Not Found'
      expect(body['details']).to eq 'No route matches'      
    end

    it "response to be successfull" do
      get '/api/v1/tasks'
      expect(response).to be_successful
    end

    it "response to be successfull with Array list of tags" do
      create_list(:random_task, 3)
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/tasks', headers: headers

      tasks = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(response).to have_http_status :ok
      expect(Task.all.size).to eq(3)
      tasks.first.each do |task|
        expect(task).to have_key(:title)
        expect(task[:title]).to be_a(String)
      end
    end

  end

  context "post /api/v1/tasks" do

    it "no route match" do
      post '/api/v1/taskss'
      body = JSON.parse response.body
      
      expect(response).to have_http_status :not_found
      expect(body['status']).to eq '404'
      expect(body['code']).to eq '4'
      expect(body['title']).to eq 'Not Found'
      expect(body['details']).to eq 'No route matches'      
    end

    it "validate blank params" do
      tag_params = {}
  
      post "/api/v1/tasks", {}
      body = JSON.parse response.body
  
      expect(response).to have_http_status '400'
      expect(body['status']).to eq '400'
      expect(body['code']).to eq '2'
      expect(body['title']).to eq 'Bad Request'
      expect(body['details']).to eq "param is missing or the value is empty: task"
    end  

    it "validate title can not be blank" do
      task_params = {
                  title: "",
                  tags: []
                }

      headers = {"CONTENT_TYPE" => "application/json"}          
      post '/api/v1/tasks', headers: headers, params: JSON.generate(task_params)
      body = JSON.parse response.body
      
      expect(response).to have_http_status '422'
      expect(body['status']).to eq '422'
      expect(body['code']).to eq '6'
      expect(body['title']).to eq 'Unprocessable Entity'
      expect(body['details']).to eq "Title can't be blank"
    end

    it "validate title should be unique" do
      create(:task)
      task_params = {
                  title: "Wash laundry",
                  tags: []                  
                }

      headers = {"CONTENT_TYPE" => "application/json"}          
      post '/api/v1/tasks', headers: headers, params: JSON.generate(task_params)
      body = JSON.parse response.body      
  
      expect(response).to have_http_status '422'
      expect(body['status']).to eq '422'
      expect(body['code']).to eq '6'
      expect(body['title']).to eq 'Unprocessable Entity'
      expect(body['details']).to eq "Title has already been taken"
    end

    it "successfully should create a task" do
      task_params = {
                  title: "Prepare Q1 report",
                  tags: []
                }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/tasks', headers: headers, params: JSON.generate(task_params)
      body = JSON.parse response.body
      
      expect(response).to have_http_status :ok
      expect(body['id']).to eq 1
      expect(body['title']).to eq 'Prepare Q1 report'
      expect(body.keys.include?('created_at')).to be(true)
      expect(body.keys.include?('updated_at')).to be(true)      
      expect(body['tags'].size.zero?).to eq true
    end

    it "successfully should create a task with tags" do
      task_params = {
                  title: "Prepare Q1 report",
                  tags: ["Home", "Today"]
                }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/tasks', headers: headers, params: JSON.generate(task_params)
      body = JSON.parse response.body
      
      expect(response).to have_http_status :ok
      expect(body['id']).to eq 1
      expect(body['title']).to eq 'Prepare Q1 report'
      expect(body.keys.include?('created_at')).to be(true)
      expect(body.keys.include?('updated_at')).to be(true)      
      expect(body['tags'].map{|x| x["title"]}).to eq ["Home", "Today"]      
    end
    
    it "successfully should create a task with existing tags" do
      create(:tag, {title: 'Home'})
      create(:tag, {title: 'Today'})
      task_params = {
                  title: "Prepare Q1 report",
                  tags: ["Home", "Today"]
                }
      headers = {"CONTENT_TYPE" => "application/json"}

      post '/api/v1/tasks', headers: headers, params: JSON.generate(task_params)
      body = JSON.parse response.body
      
      expect(response).to have_http_status :ok
      expect(body['id']).to eq 1
      expect(body['title']).to eq 'Prepare Q1 report'
      expect(body.keys.include?('created_at')).to be(true)
      expect(body.keys.include?('updated_at')).to be(true)      
      expect(body['tags'].map{|x| x["title"]}).to eq ["Home", "Today"]      
    end

  end

  context "put /api/v1/tasks" do

    it "no route match" do
      put '/api/v1/taskss'
      body = JSON.parse response.body
      
      expect(response).to have_http_status :not_found
      expect(body['status']).to eq '404'
      expect(body['code']).to eq '4'
      expect(body['title']).to eq 'Not Found'
      expect(body['details']).to eq 'No route matches'      
    end

    let(:task) { create(:task) }
    it "validate blank params" do
      task_params = {}
      headers = {"CONTENT_TYPE" => "application/json"}

      put "/api/v1/tasks/#{task.id}", headers: headers, params: JSON.generate(task_params)
      body = JSON.parse response.body
  
      expect(response).to have_http_status '400'
      expect(body['status']).to eq '400'
      expect(body['code']).to eq '2'
      expect(body['title']).to eq 'Bad Request'
      expect(body['details']).to eq "param is missing or the value is empty: task"
    end  

    it "validate title can not be blank" do
      task_params = {
                  title: ""
                }

      headers = {"CONTENT_TYPE" => "application/json"}          
      put "/api/v1/tasks/#{task.id}", headers: headers, params: JSON.generate(task_params)
      body = JSON.parse response.body
  
      expect(response).to have_http_status '422'
      expect(body['status']).to eq '422'
      expect(body['code']).to eq '6'
      expect(body['title']).to eq 'Unprocessable Entity'
      expect(body['details']).to eq "Title can't be blank"
    end

    it "validate title should be unique" do
      create(:task, {title: 'Do Homework well'})      
      task_params = {
                  title: "Do Homework well"
                }
      headers = {"CONTENT_TYPE" => "application/json"}          

      put "/api/v1/tasks/#{task.id}", headers: headers, params: JSON.generate(task_params)
      body = JSON.parse response.body      
      
      expect(response).to have_http_status '422'
      expect(body['status']).to eq '422'
      expect(body['code']).to eq '6'
      expect(body['title']).to eq 'Unprocessable Entity'
      expect(body['details']).to eq "Title has already been taken"
    end

    it "task record not found with id" do
      task_params = {
                  title: "Do Homework well"
                }
      headers = {"CONTENT_TYPE" => "application/json"}          

      put "/api/v1/tasks/101", headers: headers, params: JSON.generate(task_params)
      body = JSON.parse response.body      
      
      expect(response).to have_http_status '404'
      expect(body['status']).to eq '404'
      expect(body['code']).to eq '3'
      expect(body['title']).to eq 'Not Found'
      expect(body['details']).to eq "Couldn't find Task with 'id'=101"
    end

    it "successfully should update a Task" do
      task_params = {
                  title: "Do Homework well",
                  tags: []
                }

      headers = {"CONTENT_TYPE" => "application/json"}
      put "/api/v1/tasks/#{task.id}", headers: headers, params: JSON.generate(task_params)
      body = JSON.parse response.body
  
      expect(response).to have_http_status :ok
      expect(body['id']).to eq 1
      expect(body['title']).to eq 'Do Homework well'
      expect(body.keys.include?('created_at')).to be(true)
      expect(body.keys.include?('updated_at')).to be(true)      
    end

  end

  context "get /api/v1/tasks (final list)" do

    it "response to be successfull with Array list of tags" do
      task1 = create(:task, {title: 'Wash laundry'})
      task1.tags.find_or_create_by(title: "Home")
      task1.tags.find_or_create_by(title: "Today")

      task2 = create(:task, {title: 'Prepare Q1 report'})
      task2.tags.find_or_create_by(title: "Today")
      task2.tags.find_or_create_by(title: "Work")

      task3 = create(:task, {title: 'Do Homework well'})
      task3.tags.find_or_create_by(title: "Home")
      task3.tags.find_or_create_by(title: "Urgent")
      
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/tasks', headers: headers
      body = JSON.parse response.body
      # puts "=======> #{body.inspect}"
      # puts "=======> #{body.first.collect{|x| x["tags"]}}"

      expect(response).to have_http_status :ok
      expect(body.first.map{|x| x["title"]}).to eq ["Wash laundry", "Prepare Q1 report", "Do Homework well"]
      # expect(body.first.map{|x| x["tags"]}).to eq ["Wash laundry", "Prepare Q1 report", "Do Homework well"]
    end

  end

  context "get /api/v1/tags (pagination)" do
    it "pagination first page" do
      create_list(:random_task, 30)
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/tasks', headers: headers
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
      create_list(:random_task, 30)
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/tasks?page=2', headers: headers
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
      create_list(:random_task, 8)
      headers = {"CONTENT_TYPE" => "application/json"}

      get '/api/v1/tasks?page=2', headers: headers
      body = JSON.parse response.body

      expect(response).to have_http_status 500
      expect(body['status']).to eq '500'
      expect(body['code']).to eq '7'
      expect(body['title']).to eq 'Internal server error'
      expect(body['details']).to eq "expected :page in 1..1; got 2"
    end

  end

end