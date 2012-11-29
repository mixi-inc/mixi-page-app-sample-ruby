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
# = app/models/graph_api/client/photo.rb - Photo API用クラス
#
require_relative 'base'

# == Description
# Photo APIを叩くためのクラス
#
# == Usage
# #ユーザのTokenを渡して初期化する
# token = GraphApi::Client::Token.create_by_user_id([USER_ID])
# token.get!([AUTHORIZATION_CODE])
# photo = GraphApi::Client::Photo.new(token)
#
# # アルバムを作成する
# res = photo.create_album(title, description, visibility)
#
# # 写真をアルバムへ追加する
# res = photo.add_photo(album_id, img_path)
#
# == See also
# mixi Developer Center  Photo API
# http://developer.mixi.co.jp/connect/mixi_graph_api/mixi_io_spec_top/photo-api/

class GraphApi::Client::Photo < GraphApi::Client::Base

  ENDPOINT_PREFIX = '/2/photo'

  # アルバムを作成する
  # ---
  # *Arguments*
  # (required) title:       String
  # (required) description: String
  # (required) visibility:  String
  # (optional) options:     Hash
  # *Returns*:: JSONレスポンス: Hash
  def create_album(title, description, visibility, options={})
    endpoint = self.endpoint_myself("#{ENDPOINT_PREFIX}/albums")
    req_body = {
      title: title,
      description: description,
      privacy: {
        visibility: visibility,
        accessKey: options[:access_key] || ''
      },
    }
    post(endpoint, {body: JSON.generate(req_body)})
  end

  # 写真をアルバムへ追加する
  # ---
  # *Arguments*
  # (required) album_id:  String
  # (required) img_path:  String
  # (optional) extension: String
  # *Returns*:: JSONレスポンス: Hash
  def add_photo(album_id, img_path, extension='jpeg')
    endpoint = "#{self.endpoint_myself("#{ENDPOINT_PREFIX}/mediaItems")}/#{album_id}"
    headers = {'Content-Type' => "image/#{extension}"}
    open(img_path, "rb") do |data|
      post(endpoint, {headers: headers, body: data.read})
    end
  end

end #Photo
