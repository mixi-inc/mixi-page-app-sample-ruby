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

#
# = app/controller/resources_controller.rb - リソース操作のコントローラクラス
#

#
#
# = Description
# APIを利用してユーザのリソースを操作し、結果のレスポンスを返すためのクラス
class ResourcesController < ApplicationController


  # 自分のプロフィールを取得する
  # ---
  # *Arguments*
  # (required) X-SESSION-ID: String
  # *Returns*:: JSONレスポンス: Hash
  def lookup_my_profile
    request_api_and_render() do |token|
      people = GraphApi::Client::People.new(token)
      people.lookup_my_profile()
    end
  end

  # 友人を取得する
  # ---
  # *Arguments*
  # (required) X-SESSION-ID: String
  # *Returns*:: JSONレスポンス: Hash
  def list_friends
    request_api_and_render() do |token|
      people = GraphApi::Client::People.new(token)
      people.list_my_friends({params: {count: 10}})
    end
  end

  # 指定ページをフォローしている友人を取得する
  # ---
  # *Arguments*
  # (required) X-SESSION-ID: String
  # (required) page_id:      String
  # *Returns*:: JSONレスポンス: Hash
  def list_friends_following_page
    request_api_and_render() do |token|
      people = GraphApi::Client::People.new(token)
      people.list_friends_following_page(params['page_id'])
    end
  end

  # つぶやく
  # ---
  # *Arguments*
  # (required) X-SESSION-ID: String
  # (required) status:       String
  # *Returns*:: JSONレスポンス: Hash
  def post_voice
    request_api_and_render() do |token|
      voice = GraphApi::Client::Voice.new(token)
      voice.post_voice(params['status'])
    end
  end

  # 友人にメッセージを送る
  # ---
  # *Arguments*
  # (required) X-SESSION-ID: String
  # (required) recipients:   String
  # (required) title:        String
  # (required) body:         String
  # *Returns*:: JSONレスポンス: Hash
  def post_message
    request_api_and_render() do |token|
      message = GraphApi::Client::Message.new(token)
      message.send_message_to_users(params['recipients'], params['title'], params['body'])
    end
  end

  # アルバムに写真を追加する
  # ---
  # *Arguments*
  # (required) X-SESSION-ID: String
  # (required) album_id:     String
  # *Returns*:: JSONレスポンス: Hash
  def post_photo
    request_api_and_render() do |token|
      image_path = File.expand_path('app/assets/images/illustration/add_media_photo001.jpg', ENV['RAILS_ROOT'])
      photo = GraphApi::Client::Photo.new(token)
      photo.add_photo(params['album_id'], image_path)
    end
  end

  # カレンダーにスケジュールを作成する
  # ---
  # *Arguments*
  # (required) X-SESSION-ID:    String
  # (required) start_datetimes: String
  # (required) title:           String
  # *Returns*:: JSONレスポンス: Hash
  def post_schedule
    request_api_and_render() do |token|
      calendar = GraphApi::Client::Calendar.new(token)
      calendar.post_schedule(params['start_datetimes'], params['title'], params['visibility'])
    end
  end

  # ページアプリのコンテンツを示すURIにイイネを投稿する
  # ---
  # *Arguments*
  # (required) X-SESSION-ID: String
  # (required) page_id:      String
  # (required) content_uri:  String
  # *Returns*:: JSONレスポンス: Hash
  def post_page_like
    request_api_and_render() do |token|
      page = GraphApi::Client::Page.new(token)
      page.post_like(params['page_id'], params['content_uri'])
    end
  end

  # ページアプリのコンテンツを示すURIにコメントを投稿する
  # ---
  # *Arguments*
  # (required) X-SESSION-ID: String
  # (required) page_id:      String
  # (required) content_uri:  String
  # (required) comment:      String
  # *Returns*:: JSONレスポンス: Hash
  def post_page_comment
    request_api_and_render() do |token|
      page = GraphApi::Client::Page.new(token)
      page.post_comment(params['page_id'], params['content_uri'], params['comment'])
    end
  end

  # ブロックで指定したAPIコールを行い、結果をJSONで返却する
  # ---
  # *Arguments*
  # (required) X-SESSION-ID: String
  # *Returns*:: JSONレスポンス: Hash
  def request_api_and_render
    response = request_api_by_token() do |token|
      yield(token)
    end
    render json: response
  end

  # エラーハンドリング
  # ---
  # *Arguments*
  # *Returns*:: JSONレスポンス: Hash
  rescue_from Exception do |e|
    logger.error e.message
    render json: {:error => 'Internal Server Error'}, status: 500
  end

end

