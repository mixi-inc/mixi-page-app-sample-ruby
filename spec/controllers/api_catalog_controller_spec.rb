# Copyright (c) 2012, mixi, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#  * Neither the name of the mixi, Inc. nor the names of its contributors may
#    be used to endorse or promote products derived from this software without
#    specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

require 'spec_helper'

describe ApiCatalogController do

  describe 'GET callback' do
    it 'should redirect to main' do
      oauth = mock(GraphApi::Client::OAuth)
      oauth.stub!(:set).and_return(oauth)
      token = mock(GraphApi::Client::Token)
      token.stub!(:oauth).and_return(oauth)
      token.stub!(:get!)
      token.stub!(:user_id=)
      token.stub!(:save!)
      GraphApi::Client::Token.stub!(:create).and_return(token)
      people = mock(GraphApi::Client::People)
      people.stub!(:lookup_my_user_id).and_return('test')
      GraphApi::Client::People.stub!(:new).and_return(people)
      session = mock(ActiveRecord::SessionStore::Session)
      session.stub!(:save!)
      session.stub!(:session_id).and_return('sid')
      ActiveRecord::SessionStore::Session.stub!(:new).and_return(session)

      get 'callback', state: '{"user_id" : "test", "device" : "PC", "page_id" : "90"}', code: 'test'
      response.code.should == '302'
      response.should be_redirect
      response.should redirect_to(:action => 'main', :device =>'PC', :page_id => '90', :session_id => 'sid')
    end
  end

  describe 'POST index' do
    it 'should assign correct instance variables when opensocial_viewer_id does not exist' do
      uri_mock = mock(URI)
      uri_mock.stub!(:path).and_return('/test')
      URI.stub!(:parse).and_return(uri_mock)
      URI.stub!(:escape).and_return('fuga')
      Net::HTTP::Post.stub!(:new).and_return('hoge')
      OAuth::Consumer.stub!(:new).and_return('hoge')
      signature = mock(OAuth::Signature)
      signature.stub!(:verify).and_return(true)
      OAuth::Signature.stub!(:build).and_return(signature)

      post 'index', device: 'PC', mixi_page_id: '90'
      response.code.should == '200'
      assigns(:scope).should == 'r_profile w_voice w_message w_photo w_calendar w_pagefeed'
      assigns(:device).should == 'PC'
      assigns(:consumer_key).should == 'key'
      assigns(:relay_url).should == 'http://www.app.com/mixi.html'
      assigns(:state).should == '%7B%22device%22%3A%22PC%22%2C%22page_id%22%3A%2290%22%7D'
    end

    it 'should assign correct instance variables when mixi_viewer_id and a session exist' do
      uri_mock = mock(URI)
      uri_mock.stub!(:path).and_return('/test')
      URI.stub!(:parse).and_return(uri_mock)
      URI.stub!(:escape).and_return('fuga')
      Net::HTTP::Post.stub!(:new).and_return('hoge')
      OAuth::Consumer.stub!(:new).and_return('hoge')
      signature = mock(OAuth::Signature)
      signature.stub!(:verify).and_return(true)
      OAuth::Signature.stub!(:build).and_return(signature)
      session_store = mock(ActiveRecord::SessionStore)
      session_store.stub!(:generate_sid).and_return('sid')
      ActiveRecord::SessionStore.stub!(:new).and_return(session_store)
      session = mock(ActiveRecord::SessionStore::Session)
      session.stub!(:save!)
      session.stub!(:session_id).and_return('new_sid')
      session.stub!(:data).and_return('data')
      ActiveRecord::SessionStore::Session.stub!(:find_by_data).and_return(session)

      post 'index', device: 'PC', mixi_page_id: '90', mixi_viewer_id: 'viewer'
      response.code.should == '302'
      response.should be_redirect
      response.should redirect_to(:action => 'main', :device =>'PC', :page_id => '90', :session_id => 'new_sid')
    end

    it 'should assign correct instance variables when mixi_viewer_id exists' do
      uri_mock = mock(URI)
      uri_mock.stub!(:path).and_return('/test')
      URI.stub!(:parse).and_return(uri_mock)
      URI.stub!(:escape).and_return('fuga')
      Net::HTTP::Post.stub!(:new).and_return('hoge')
      OAuth::Consumer.stub!(:new).and_return('hoge')
      signature = mock(OAuth::Signature)
      signature.stub!(:verify).and_return(true)
      OAuth::Signature.stub!(:build).and_return(signature)
      session_store = mock(ActiveRecord::SessionStore)
      session_store.stub!(:generate_sid).and_return('sid')
      ActiveRecord::SessionStore.stub!(:new).and_return(session_store)
      ActiveRecord::SessionStore::Session.stub!(:find_by_data).and_return(nil)

      post 'index', device: 'PC', mixi_page_id: '90', mixi_viewer_id: 'viewer'
      response.code.should == '302'
      response.should be_redirect
      response.should redirect_to(:action => 'main', :device =>'PC', :page_id => '90', :session_id => 'sid')
    end
  end

  describe 'GET main' do
    it 'should assign correct instance variables' do

      session = mock(ActiveRecord::SessionStore::Session)
      session.stub!(:delete)
      session.stub!(:session_id).and_return('sesison_id')
      session.stub!(:data).and_return('user_id')
      ActiveRecord::SessionStore::Session.stub!(:find_by_session_id!).and_return(session)

      session_store = mock(ActiveRecord::SessionStore)
      session_store.stub!(:generate_sid).and_return('new_sid')
      ActiveRecord::SessionStore.stub!(:new).and_return(session_store)

      new_session = mock(ActiveRecord::SessionStore::Session)
      new_session.stub!(:save!)
      new_session.stub!(:session_id).and_return('new_sid')
      ActiveRecord::SessionStore::Session.stub!(:new).and_return(new_session)


      get 'main', device: 'device', session_id: 'sid', page_id: '90'
      response.code.should == '200'

      assigns(:consumer_key).should == 'key'
      assigns(:app_url).should == 'http://www.app.com'
      assigns(:relay_url).should == 'http://www.app.com/mixi.html'
      assigns(:device).should == 'device'
      assigns(:session_id).should == 'new_sid'
    end
  end


end
