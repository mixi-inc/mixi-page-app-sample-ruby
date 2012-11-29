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
# = app/controller/api_catalog_controller.rb - アプリのコントローラクラス
#

#
#
# = Description
# アプリケーションの画面遷移、モデルからのレスポンスを返すためのクラス
class ApiCatalogController < ApplicationController

  # PC用 OAuth Signatureの検証用公開鍵
  # http://developer.mixi.co.jp/page-apps/spec/summary/
  PC_PUBLIC_KEY =<<-EOS.gsub(/^\s*/, "")
  -----BEGIN CERTIFICATE-----
  MIIDfDCCAmSgAwIBAgIJAIzC8GwwTFzxMA0GCSqGSIb3DQEBBQUAMDIxCzAJBgNV
  BAYTAkpQMREwDwYDVQQKEwhtaXhpIEluYzEQMA4GA1UEAxMHbWl4aS5qcDAeFw0x
  MTA1MjQwNTMxMTBaFw0xMzA1MjMwNTMxMTBaMDIxCzAJBgNVBAYTAkpQMREwDwYD
  VQQKEwhtaXhpIEluYzEQMA4GA1UEAxMHbWl4aS5qcDCCASIwDQYJKoZIhvcNAQEB
  BQADggEPADCCAQoCggEBAMbpHo2BGgxSDO9jQmFoWEwscPJV/96LMtBNq7qm3NuD
  8vX8Y1zF5VTKzpOhlX9uvOMrmOaWkMnPcQK2WxbocyB6lCF3Ewv41dR3lfR3oVbX
  mF9tx+lLDYxyp5qoDzk/aOIgh0YHbwGuWwP8/kCwd2wUuXO6qMEEEOrqIafmGJdZ
  KKFWwNSV8h4K1/guP4XK3gwTeiawJzYcKwHM+tMHAZax58HPr7lMbN0DGeeNXjW9
  dNKqYjRw9XcTtv9ZQIcSvU+9c/dZHk3cm963vrxvtVsA4V/VSBaf6X0WJ44am//c
  954poRVR0TA/4X76ZIgEKT12/H1MVJn4rQsrGtK4U68CAwEAAaOBlDCBkTAdBgNV
  HQ4EFgQUVrpcuj6H3rI0IU7ZDBhIC7dCshwwYgYDVR0jBFswWYAUVrpcuj6H3rI0
  IU7ZDBhIC7dCshyhNqQ0MDIxCzAJBgNVBAYTAkpQMREwDwYDVQQKEwhtaXhpIElu
  YzEQMA4GA1UEAxMHbWl4aS5qcIIJAIzC8GwwTFzxMAwGA1UdEwQFMAMBAf8wDQYJ
  KoZIhvcNAQEFBQADggEBAAkOHmJINcm8UEQWWSuYjIiwA/xSuFJKpGqSe3VAn2Gm
  4W9seLN14duuu/CsNL31ih1jnSrYtzlOdmVwUOeYi5yhyHNkWtw1wSOQA8i+IFCt
  WKXsxYyPblKjsNB9x3VyFSZYw+v41mVFQQGDH4V1JwyJW9Aebffv6oKROTkaIdt/
  J5YoB712zHKVm0rZue3eUHdMiSIJLzhR6bL2bKV13wGSeKf7RBX/9lFTSVsyc9MQ
  vjAOYWeGFYpup624CGWKPG+PEQe7vaDycaFHd0TPgoxLukUHkZhxvXo+tiweKnwI
  WcfqZCQCnoPfIDIoVWFdMw6T9hJLICb5a8f05k1JFoQ=
  -----END CERTIFICATE-----
  EOS

  # Touch用 OAuth Signatureの検証用公開鍵
  # http://developer.mixi.co.jp/page-apps/spec/summary/
  TO_PUBLIC_KEY =<<-EOS.gsub(/^\s*/, "")
  -----BEGIN CERTIFICATE-----
  MIIDfDCCAmSgAwIBAgIJALlFXlCiAFLyMA0GCSqGSIb3DQEBBQUAMDIxCzAJBgNV
  BAYTAkpQMREwDwYDVQQKEwhtaXhpIEluYzEQMA4GA1UEAxMHbWl4aS5qcDAeFw0x
  MTA3MDYwMTE5MjJaFw0xMzA3MDUwMTE5MjJaMDIxCzAJBgNVBAYTAkpQMREwDwYD
  VQQKEwhtaXhpIEluYzEQMA4GA1UEAxMHbWl4aS5qcDCCASIwDQYJKoZIhvcNAQEB
  BQADggEPADCCAQoCggEBAN21pHE0zoW5NF+0Qd0h10Lc+obTnn6uKV247xezGam5
  vP0+729zo0Ch46abF9B5SUIk3/kFfrwWU73UB8j9GJPcx6dN/SB4C/EpYPanbK7N
  FohgLPh+uihB3brOfe0fCYQUzfh5lgfzzHyNxR7vE5ErVvQH2YMC1dX0LnE70m3y
  +8QTQpq0My2FvttBAZwr2wV4mG/xuvxR3sXtzkTf7DLkRXCcuImMrRd+AI8oi9sG
  xfB8ThFekgc9TARVgUiCgC/RNrIWmwh2s7ivCFDRPMfTJlNGTTu10SegS6+1cZgY
  93/2fzsIUl86nxaNmLAu3+nzct/364lIwSB9/8hvsiUCAwEAAaOBlDCBkTAdBgNV
  HQ4EFgQUqvQ+ztpLlBlv27Tmj+cXZn+7s/0wYgYDVR0jBFswWYAUqvQ+ztpLlBlv
  27Tmj+cXZn+7s/2hNqQ0MDIxCzAJBgNVBAYTAkpQMREwDwYDVQQKEwhtaXhpIElu
  YzEQMA4GA1UEAxMHbWl4aS5qcIIJALlFXlCiAFLyMAwGA1UdEwQFMAMBAf8wDQYJ
  KoZIhvcNAQEFBQADggEBADDwaSXWL755GVQ5hcWEQGAQZFIpK1LSUuup0i2cRwAF
  QnQE5cyQcQuy2qE7+dqSz6RHtRW4fnaJygPmpM912xjdG0Hbo/grKbrkVrpa1Hg5
  Oi1ffKBUhT9ygttv/FxJDy3d7wqHgQXPT/Qkp1VJE6q24uKDHyEB/FiL01lbgZWm
  73pSvRPXTBr2CY21SfPfhLzQoulr4KYx57U9C8BJoNJKXoHgOZ00NbDcc8VyB59H
  RPtjxzf6g1yUOuefBoshCryaixWqmIUmv6RcE3ZGB5MCyJi8K3qo0Keo2W7HBH0t
  NW1Lho60tFXYbHDeXiYlw3dT+R+al9zojfOUB3sJ/vU=
  -----END CERTIFICATE-----
  EOS


  # 認証後のリダイレクト先
  def callback
    if params[:error] == 'access_denied'
      render status: 403, file: "#{Rails.root}/public/403.html" and return
    end

    state = JSON.parse(params[:state])
    token = GraphApi::Client::Token.create
    token.oauth.set(CONSUMER_KEY, CONSUMER_SECRET, REDIRECT_URL)
    token.get!(params[:code])
    people = GraphApi::Client::People.new(token)
    user_id = people.lookup_my_user_id
    raise 'Can\'t find user_id.' if user_id.nil?
    token.user_id = user_id
    token.save!

    session = create_session(ActiveRecord::SessionStore.new('').generate_sid, user_id)

    redirect_to main_path(device: state['device'], session_id: session.session_id, page_id: state['page_id'])
  end

  # タイトル画面を表示
  def index
    start_page_url = URI.parse(request.url)
    if verify_oauth_signature?(start_page_url)
      session_id = ''
      viewer_id  = params[:mixi_viewer_id]
      if viewer_id
        session = find_session_by_uid(viewer_id) ||
          create_session(ActiveRecord::SessionStore.new('').generate_sid, viewer_id)
        redirect_to main_path(device: params[:device], session_id: session.session_id, page_id: params[:mixi_page_id])
      end
      @scope        = 'r_profile w_voice w_message w_photo w_calendar w_pagefeed'
      @device       = params[:device]
      @page_id      = params[:mixi_page_id]
      @consumer_key = CONSUMER_KEY
      @relay_url    = RELAY_URL
      @state        = CGI.escape(JSON({ device: @device, page_id: @page_id }))
    else
      logger.error 'verification failed'
      render status: 500, file: "#{Rails.root}/public/unauthorized.html"
    end
  end

  # メイン表示
  def main
    session = verify_and_regenerate_session(params[:session_id]);
    @consumer_key = CONSUMER_KEY
    @app_url      = APP_URL
    @relay_url    = RELAY_URL
    @session_id   = session.session_id
    @device       = params[:device]
    @page_id      = params[:page_id]
  end


  # 起動時に与えられるOAuth Signatureを検証する。
  # ---
  # *Arguments*
  #  start_page_url: String
  #
  def verify_oauth_signature?(start_page_url)
    #OAuth::Signatureでbase_stringを作成するために必要な、url query stringの構築
    params.delete('action')
    params.delete('controller')

    #deviceの判定と認証用鍵の切り替え
    public_key = ""
    case params['device']
    when 'PC'
      public_key = PC_PUBLIC_KEY
    when 'TO'
      public_key = TO_PUBLIC_KEY
    else
      return false
    end

    query_string = params.map{|k, v| "#{k}=#{v.gsub(/\r\n/, "").gsub('+', '%2B')}"}.join("&")

    #postされたsignatureをpublic keyで復号化し、OAuth::Signature内で構築されたbase_stringと比較
    post = Net::HTTP::Post.new("#{start_page_url.path}?#{query_string}")
    consumer = OAuth::Consumer.new('', OpenSSL::X509::Certificate.new(public_key))
    signature = OAuth::Signature.build(post, {uri: start_page_url.to_s, consumer: consumer})

    return (signature.verify) ? true : false
  end

  # エラーハンドリング
  # ---
  # *Arguments*
  # *Returns*:: JSONレスポンス: Hash
  rescue_from Exception do |e|
    logger.error e.message
    render status: 500, file: "#{Rails.root}/public/500.html"
  end

end
