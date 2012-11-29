# -*- encoding: utf-8 -*-
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

#
# = app/models/graph_api/client/message.rb - Message API用クラス
#
require_relative 'base'

# == Description
# Message APIを叩くためのクラス
#
# == Usage
# #ユーザのTokenを渡して初期化する
# token = GraphApi::Client::Token.create_by_user_id([USER_ID])
# token.get!([AUTHORIZATION_CODE])
# message = GraphApi::Client::Message.new(token)
#
# #ユーザを指定してメッセージを送る
# res = message.send_message_to_users(recipient, title, body)
#
# #メッセージに対して返信をする
# res = message.replay_message(inReplyTo, title, body)
#
# == See also
# mixi Developer Center  Message API
# http://developer.mixi.co.jp/connect/mixi_graph_api/mixi_io_spec_top/message-api/

class GraphApi::Client::Message < GraphApi::Client::Base

  ENDPOINT_PREFIX = '/2/messages'

  attr_reader :inbox, :outbox, :noticebox

  # 送信済みBOXをendpointを返す
  # ---
  # *Returns*:: JSONレスポンス: Hash
  def outbox
    @outbox ||= "#{self.endpoint_myself(ENDPOINT_PREFIX)}/@outbox"
  end

  # 受信BOXのendpointを返す
  # ---
  # *Returns*:: endpointの相対パス: String
  def inbox
    @inbox ||= "#{self.endpoint_myself(ENDPOINT_PREFIX)}/@inbox"
  end

  # mixiからの通知を受け取る受信BOXのendpointを返す
  # ---
  # *Returns*:: endpointの相対パス: String
  def noticebox
   @noticebox ||= "#{self.endpoint_myself(ENDPOINT_PREFIX)}/@noticebox"
  end

  # メッセージを送る
  # ---
  # *Arguments*
  #  (optional) req_body : Hash 
  # *Returns*:: JSONレスポンス: Hash
  def send_message(req_body={})
    post(outbox, {body: JSON.generate(req_body)})
  end

  # ユーザを指定してメッセージを送る
  # ---
  # *Arguments*
  # (required) recipients: Array
  # (required) title:      String
  # (required) body:       String
  # *Returns*:: JSONレスポンス: Hash
  def send_message_to_users(recipients, title, body)
    req_body = {
        recipients: recipients,
        title: title,
        body:  body
    }
    send_message(req_body)
  end

  # メッセージに返信する
  # ---
  # *Arguments*
  # (required) in_reply_to: String
  # (optional) title:       String
  # (required) body:        String
  # *Returns*:: JSONレスポンス: Hash
  def reply_message(in_reply_to, title="", body)
    req_body = {
        inReplyTo: in_reply_to,
        title: title,
        body:  body
    }
    send_message(req_body)
  end

end #Message
