/*
 * Copyright (c) 2012, mixi, Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *  * Neither the name of the mixi, Inc. nor the names of its contributors may
 *    be used to endorse or promote products derived from this software without
 *    specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

if (typeof(qs) === 'undefined') {
   qs = {};
}
qs.api = {

    sid: '',
    defaultCallback: function(data) {
        if (data.error) {
            qs.dialog.showMsg('Error', data.error);
        }
    },


   /**
    * つぶやく
    * @param {String} status つぶやき内容
    * @param {Function} callback コールバック
    */
    postVoice: function(status, callback) {
        this.send(
            'post_voice',
            'POST',
            {
                status: status
            },
            callback || this.defaultCallback
        );
    },

   /**
    * 指定の友人にメッセージを送る
    * @param {String} userId 送り先ユーザID
    * @param {String} title 件名
    * @param {String} body 本文
    * @param {Function} callback コールバック
    */
    postMessage: function(userId, title, body, callback) {
        this.send(
            'post_message',
            'POST',
            {
                recipients: [userId],
                title: title,
                body: body
            },
            callback || this.defaultCallback
        );
    },

   /**
    * サーバにある写真をユーザのアルバムに登録する
    * @param {String} album_id アルバムID　例）簡単公開アルバム='@default'
    * @param {Function} callback コールバック
    */
    postPhoto: function(albumId, callback) {
        this.send(
            'post_photo',
            'POST',
            {
                album_id: albumId
            },
            callback || this.defaultCallback
        );
    },

   /**
    * ユーザのカレンダーに予定を登録する
    * @param {String} startDatetimes 開始日時 例）'2012-11-11T00:00:00+09:00'
    * @param {String} title 予定の名前
    * @param {String} visibility 公開範囲 例）'everyone', 'friends', 'self' etc..
    * @param {Function} callback コールバック
    */
    postSchedule: function(startDatetimes, title, visibility, callback) {
        this.send(
            'post_schedule',
            'POST',
            {
                start_datetimes: startDatetimes,
                title: title,
                visibility: visibility
            },
            callback || this.defaultCallback
        );
    },

   /**
    * コンテンツを示すURIにイイネを投稿する
    * @param {String} pageId mixiページID
    * @param {String} contentUri コンテンツを示すURI
    * @param {Function} callback コールバック
    */
    postPageLike: function(pageId, contentUri, callback) {
        this.send(
            'post_page_like',
            'POST',
            {
                page_id: pageId,
                content_uri: contentUri
            },
            callback || this.defaultCallback
        );
    },

   /**
    * コンテンツを示すURIにコメントを投稿する
    * @param {String} pageId mixiページID
    * @param {String} contentUri コンテンツを示すURI
    * @param {String} comment コメント内容
    * @param {Function} callback コールバック
    */
    postPageComment: function(pageId, contentUri, comment, callback) {
        this.send(
            'post_page_like',
            'POST',
            {
                page_id: pageId,
                content_uri: contentUri,
                comment: comment
            },
            callback || this.defaultCallback
        );
    },

   /**
    * 自分のプロフィールを取得する
    * @param {Function} callback コールバック
    */
    lookupProfile: function(callback) {
        this.send(
            'lookup_my_profile',
            'GET',
            {},
            callback || this.defaultCallback
        );
    },

   /**
    * 友人一覧を取得する
    * @param {Function} callback コールバック
    */
    listFriends: function(callback) {
        this.send(
            'list_friends',
            'GET',
            {},
            callback || this.defaultCallback
        );
    },

   /**
    * 指定のmixiページをフォローしている友人一覧を取得する
    * @param {String} pageId mixiページID
    * @param {Function} callback コールバック
    */
    listFollowers: function(pageId, callback) {
        this.send(
            'list_friends_following_page',
            'GET',
            {
                page_id: pageId
            },
            callback || this.defaultCallback
        );
    },

    send: function(url, method, data, callback) {
        $.ajax({
            url: url,
            type: method,
            headers: { 'X-SESSION-ID': this.sid },
            data: data,
            success: callback,
            error: function(xhr, status, error){
                qs.dialog.showMsg(status, error);
            }
        });
    }

};



qs.dialog = {

   /**
    * メッセージダイアログを表示
    * @param {String} title タイトル
    * @param {String} msg 表示するメッセージ
    * @param {Function} callback コールバック
    */
    showMsg: function(title, msg, callback) {
        this.show(title, 130, 300, this.msgHTML(msg), callback);
    },

   /**
    * ダイアログを表示
    * @param {String} title タイトル
    * @param {String} height ダイアログの高さ
    * @param {String} width ダイアログの幅
    * @param {String} html jQueryのhtmlオブジェクト
    * @param {Function} callback コールバック
    */
    show: function(title, height, width, html, callback) {
        var buttons = {};
        if (callback) {
            buttons = {"OK": callback};
        }
        var top  = Math.floor((600 - height) / 2);
        var left = Math.floor(($(window).width() - width) / 2);
        $('#result-dialog').empty();
        $('#result-dialog').append(html);
        $('#result-dialog').dialog({
            title: title,
            height: height,
            width: width,
            resizable: false,
            position: [left, top],
            modal: true,
            buttons: buttons
        });
    },

    msgHTML: function(msg) {
        return $('<div>').text(msg);
    }

};


