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
# = app/models/graph_api/client/page.rb - Page API用クラス
#
require_relative 'base'

# == Description
# Page APIを叩くためのクラス
#
# == Usage
# #ユーザのTokenを渡して初期化する
# token = GraphApi::Client::Token.create_by_user_id([USER_ID])
# token.get!([AUTHORIZATION_CODE])
# page = GraphApi::Client::Page.new(token)
#
# #コンテンツを示すURIにコメントをする
# res = page.post_comment(page_id, content_uri, comment)
#
# #コンテンツを示すURIにイイネをする
# res = page.post_like(page_id, content_uri)
#
# == See also
# mixi Developer Center  Page API
# http://developer.mixi.co.jp/connect/mixi_graph_api/mixi_io_spec_top/page_api/

class GraphApi::Client::Page < GraphApi::Client::Base

  ENDPOINT_PREFIX = '/2/pages'

  # コンテンツを示すURIにコメントをする
  # ---
  # *Arguments*
  # (required) page_id:     String
  # (required) content_uri: String
  # (required) comment:     String
  # *Returns*:: JSONレスポンス: Hash
  def post_comment(page_id, content_uri, comment)
    endpoint = "#{ENDPOINT_PREFIX}/#{page_id}/comments"
    params   = { contentUri: content_uri }
    req_body = {
      comment: comment,
    }
    post(endpoint, { params: params, body: JSON.generate(req_body) })
  end

  # コンテンツを示すURIにイイネをする
  # ---
  # *Arguments*
  # (required) page_id:     String
  # (required) content_uri: String
  # *Returns*:: JSONレスポンス: Hash
  def post_like(page_id, content_uri)
    endpoint = "#{ENDPOINT_PREFIX}/#{page_id}/favorites"
    params   = { contentUri: content_uri }
    post(endpoint, { params: params })
  end

end #Page
