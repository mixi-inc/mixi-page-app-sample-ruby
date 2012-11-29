require 'spec_helper'

describe ResourcesController do

  before(:each) do
    session = mock(ActiveRecord::SessionStore::Session)
    session.stub!(:data).and_return('user_id')
    ActiveRecord::SessionStore::Session.stub!(:find_by_session_id).and_return(session)
    token = mock(GraphApi::Client::Token)
    token.stub!(:nil?).and_return(false)
    token.stub!(:expired?).and_return(false);
    token.stub!(:access_token).and_return('aaaaaa');
    oauth = mock(GraphApi::Client::OAuth)
    oauth.stub!(:set).and_return(oauth)
    token.stub!(:oauth).and_return(oauth)
    GraphApi::Client::Token.stub!(:find_by_user_id).and_return(token)
  end

  describe 'GET lookup_my_profile' do
    it 'should render a json value' do
      response = {status: 200}
      people = mock(GraphApi::Client::People)
      people.stub!(:lookup_my_profile).with().and_return(response)
      GraphApi::Client::People.stub!(:new).and_return(people)

      get 'lookup_my_profile'
      response.should == response
    end
  end

  describe 'GET list_friends' do
    it 'should render a json value' do
      response = {status: 200}
      people = mock(GraphApi::Client::People)
      people.stub!(:list_my_friends).with({params: {count: 10}}).and_return(response)
      GraphApi::Client::People.stub!(:new).and_return(people)

      get 'list_friends'
      response.should == response
    end
  end

  describe 'POST post_voice' do
    it 'should render a json value' do
      response = {status: 200}
      voice = mock(GraphApi::Client::Voice)
      voice.stub!(:post_voice).with('status').and_return(response)
      GraphApi::Client::Voice.stub!(:new).and_return(voice)

      post 'post_voice', {status: 'status'}
      response.should == response
    end
  end

  describe 'POST post_message' do
    it 'should render a json value' do
      response = {status: 200}
      message = mock(GraphApi::Client::Message)
      message.stub!(:send_message_to_users).with(['1234'], 'title', 'body').and_return(response)
      GraphApi::Client::Message.stub!(:new).and_return(message)

      post 'post_message', {recipents: '1234', title: 'title', body: 'body'}
      response.should == response
    end
  end

  describe 'POST post_photo' do
    it 'should render a json value' do
      response = {status: 200}
      image_path = File.expand_path('app/assets/images/illustration/add_media_photo001.jpg', ENV['RAILS_ROOT'])
      photo = mock(GraphApi::Client::Photo)
      photo.stub!(:add_photo).with('@default', image_path).and_return(response)
      GraphApi::Client::Photo.stub!(:new).and_return(photo)

      post 'post_photo', {album_id: '@default'}
      response.should == response
    end
  end

  describe 'POST post_schedule' do
    it 'should render a json value' do
      response = {status: 200}
      calendar = mock(GraphApi::Client::Calendar)
      calendar.stub!(:post_schedule).with('2012-01-01T00:00:00+09:00', 'title').and_return(response)
      GraphApi::Client::Calendar.stub!(:new).and_return(calendar)

      post 'post_schedule', {start_datetimes: '2012-01-01T00:00:00+09:00', title: 'title'}
      response.should == response
    end
  end

  describe 'POST post_page_like' do
    it 'should render a json value' do
      response = {status: 200}
      page = mock(GraphApi::Client::Page)
      page.stub!(:post_like).with('1234', 'http://example.com').and_return(response)
      GraphApi::Client::Page.stub!(:new).and_return(page)

      post 'post_page_like', {page_id: '1234', content_uri: 'http://example.com'}
      response.should == response
    end
  end

  describe 'POST post_page_comment' do
    it 'should render a json value' do
      response = {status: 200}
      page = mock(GraphApi::Client::Page)
      page.stub!(:post_comment).with('1234', 'http://example.com', 'comment').and_return(response)
      GraphApi::Client::Page.stub!(:new).and_return(page)

      post 'post_page_comment', {page_id: '1234', content_uri: 'http://example.com', comment: 'comment'}
      response.should == response
    end
  end

end
