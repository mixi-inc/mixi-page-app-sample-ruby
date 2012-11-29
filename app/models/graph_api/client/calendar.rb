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
# = app/models/graph_api/client/calendar.rb - Calendar API用クラス
#

require 'json'

require_relative 'base'

# == Description
# Calendar APIを叩くためのクラス
#
# == Usage
# #ユーザのTokenを渡して初期化する
# token = GraphApi::Client::Token.create("etgea4323dd")
# token.get!("agfeaefgrbvgarhraegf45tqgravdfagqatwrb5b42")
# calendar = GraphApi::Client::Calendar.new(token)
#
# #スケジュールを登録する
# res = calendar.post_schedule(start_datetimes, title)
#
# == See also
# mixi Developer Center  Calendar API
# http://developer.mixi.co.jp/connect/mixi_graph_api/mixi_io_spec_top/calendar-api/

class GraphApi::Client::Calendar < GraphApi::Client::Base

  ENDPOINT_PREFIX = '/2/calendar/schedules'

  # スケジュールを登録する
  # ---
  # *Arguments*
  # (required) start_datetimes: String
  # (required) title:           String
  # (optional) visibility:      String
  # (optional) options:         Hash
  # *Returns*:: JSONレスポンス: Hash
  def post_schedule(start_datetimes, title, visibility='everyone', options={})
    req_body = {
      startDatetimes: start_datetimes,
      title: title,
      description: options[:description] || '',
      invite: options[:invite] || 0,
      privacy: {
        visibility: visibility,
      },
      attendees: options[:attendees] || []
    }
    post(self.endpoint_myself(ENDPOINT_PREFIX), { body: JSON.generate(req_body) })
  end

end #Calendar
