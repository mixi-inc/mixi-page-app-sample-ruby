# -*- coding: utf-8 -*-
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

class ApplicationController < ActionController::Base

  CONSUMER_KEY     = ENV['MIXI_CONSUMER_KEY']
  CONSUMER_SECRET  = ENV['MIXI_CONSUMER_SECRET']
  APP_URL          = ENV['MIXI_APP_URL']
  REDIRECT_URL     = URI.join(APP_URL, 'callback').to_s
  RELAY_URL        = URI.join(APP_URL, 'mixi.html').to_s


  # session_idからuser_idを取得する
  # ---
  # *Arguments*
  #  session_id: String
  #
  # *Return*: session data(String)
  def find_user_id_by_session_id(session_id)
    ActiveRecord::SessionStore::Session.find_by_session_id(session_id).data
  end

  # session情報を作成する
  # ---
  # *Arguments*
  #  session_id: String
  #  user_id: String
  #
  # *Return*: session (ActiveRecord::SessionStore::Session)
  def create_session(session_id, user_id)
    session = ActiveRecord::SessionStore::Session.new(
        session_id: session_id,
        data:       user_id
    )
    session.save!
    session
  end

  # user_idからsessionを取得する
  # ---
  # *Arguments*
  #  user_id: String
  #
  # *Return*: session (ActiveRecord::SessionStore::Session)
  def find_session_by_uid(user_id)
    ActiveRecord::SessionStore::Session.find_by_data(
      ActiveRecord::SessionStore::Session.marshal(user_id))
  end

  # session_idの妥当性検証し、session_idを再発行する
  # ---
  # *Arguments*
  #  session_id: String
  #
  # *Return*: session (ActiveRecord::SessionStore::Session)
  def verify_and_regenerate_session(session_id)
    session = ActiveRecord::SessionStore::Session.find_by_session_id!(session_id)
    session.delete
    @session_id = ActiveRecord::SessionStore.new('').generate_sid
    create_session(@session_id, session.data)
  end

  # session idからtokenを取得／APIでエラーが発生した時の処理を受け持つ
  # ---
  # *Arguments*
  #  session_id: String
  #  &block:     Proc
  # *Return*: response (Hash)
  def request_api_by_token(session_id=request.headers['X-SESSION-ID'], &block)
    user_id = find_user_id_by_session_id(session_id)
    token = GraphApi::Client::Token.find_by_user_id!(user_id)
    token.oauth.set(CONSUMER_KEY, CONSUMER_SECRET, REDIRECT_URL)
    block.call token
  end


end
