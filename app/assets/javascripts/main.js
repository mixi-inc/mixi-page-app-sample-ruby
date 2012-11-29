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

/**
 * main.html.erbの要素に関するJS処理
 */

$(function(){

    /**
     * 初期化処理
     */
    function init() {
        // JS API 初期化処理
        // See: http://developer.mixi.co.jp/page-apps/spec/javascript-api/
        mixi.init({
            appId: $('#appId').val(),
            relayUrl: $('#relayUrl').val()
        });

        qs.api.sid = $('#sid').val();
    }

    /**
     * ボタン等にイベントを設定
     */
    function setButtonsEvents(userdata) {
        var disp = $('#display');

       /**
        * 以下、画面遷移
        */

        // メニューへ戻る
        disp.on('click', '#btnGoToMenu', function() {
            disp.html(
                $('#tmplMenu').tmpl()
            );
        });

        // 友人一覧を表示
        disp.on('click', '#btnGoToFriends', function() {
            disp.html(
                $('#tmplFriends').tmpl()
            );
        });

        // つぶやきを投稿
        disp.on('click', '#btnGoToVoice', function() {
            disp.html(
                $('#tmplVoice').tmpl(userdata)
            );
        });

        // カレンダーに予定を登録
        disp.on('click', '#btnGoToCalendar', function() {
            disp.html(
                $('#tmplCalendar').tmpl(userdata)
            );
        });

        // 友人にメッセージを送信
        disp.on('click', '#btnGoToMessage', function() {
            disp.html(
                $('#tmplMessage').tmpl(userdata)
            );
        });

        // 写真をアルバムに登録
        disp.on('click', '#btnGoToPhoto', function() {
            disp.html(
                $('#tmplPhoto').tmpl(userdata)
            );
        });

        // ページをフォローしている友人一覧を表示
        disp.on('click', '#btnGoToFollowers', function() {
            disp.html(
                $('#tmplFollowers').tmpl()
            );
        });

        // アプリのコンテンツにコメントする
        disp.on('click', '#btnGoToComment', function() {
            disp.html(
                $('#tmplComment').tmpl()
            );
        });

        // アプリのコンテンツにイイネする
        disp.on('click', '#btnGoToLike', function() {
            disp.html(
                $('#tmplLike').tmpl()
            );
        });



       /**
        * 以下、リソースの取得／投稿
        */

        // 友人一覧を表示
        disp.on('click', '#btnFriends', function() {
            qs.api.listFriends(function(data) {
                if (data.error) {
                    qs.dialog.showMsg('Error', data.error);
                    return;
                }
                qs.dialog.show('友人一覧', 300, 300, $('#tmplShowFriend').tmpl(data.entry));
            });
        });

        // つぶやく
        disp.on('click', '#btnVoice', function() {
            var status = $.trim($('#voiceStatus').val());
            if (status.length == 0) {
                qs.dialog.showMsg('Error', 'つぶやき内容を入力してください');
                return;
            }
            qs.api.postVoice(status, postCallback);
        });

        // 予定を登録する
        disp.on('click', '#btnCalendar', function() {
            var year  = $('#calYear').val();
            var month = $('#calMonth').val();
            var day   = $('#calDay').val();
            var time  = $('#calTime').val();
            var startDateTime = year + '-' + month + '-' + day + 'T' + time + ':00+09:00';
            var title = $('#calTitle').val();
            var visibility = $('#calVisibility').val();
            qs.api.postSchedule(startDateTime, title, visibility, postCallback);
        });

        // メッセージを送る
        disp.on('click', '#btnMessage', function() {
            var userId = $.trim($('#selectedUserId').val());
            var title  = $.trim($('#msgTitle').val());
            var body   = $.trim($('#msgBody').val());
            if (userId.length == 0) {
                qs.dialog.showMsg('Error', 'サムネイルをクリックして、送り先を選択してください');
                return;
            }
            if (title.length == 0 || body.length == 0) {
                qs.dialog.showMsg('Error', '件名とメッセージ内容を入力してください');
                return;
            }
            qs.api.postMessage(userId, title, body, postCallback);
        });

        // アルバムへクリップ
        disp.on('click', '#btnPhoto', function() {
            qs.api.postPhoto('@default', postCallback);
        });

        // 友人一覧を表示（フォロワー）
        disp.on('click', '#btnFollowers', function() {
            var pageId = $('#pageId').val();
            qs.api.listFollowers(pageId, function(data) {
                if (data.error) {
                    qs.dialog.showMsg('Error', data.error);
                    return;
                }
                qs.dialog.show('友人一覧', 300, 300, $('#tmplShowFriend').tmpl(data.entry));
            });
        });

        // コメントを登録する
        disp.on('click', '#btnComment', function() {
            var pageId = $('#pageId').val();
            var contentUri = $('#appUrl').val() + 'contents/1';
            var comment = $.trim($('#pageComment').val());
            if (comment.length == 0) {
                qs.dialog.showMsg('Error', 'コメント内容を入力してください');
                return;
            }
            qs.api.postPageComment(pageId, contentUri, comment, postCallback);
        });

        // イイネ！する
        disp.on('click', '#btnLike', function() {
            var pageId = $('#pageId').val();
            var contentUri = $('#appUrl').val() + 'contents/1';
            qs.api.postPageLike(pageId, contentUri, postCallback);
        });

        // メッセージの友人選択
        disp.on('click', '#btnMessageFriends', function() {
            qs.api.listFriends(function(data) {
                if (data.error) {
                    qs.dialog.showMsg('Error', data.error);
                    return;
                }
                qs.dialog.show('送り先選択', 300, 300, $('#tmplSelectFriend').tmpl(data.entry));
                $('.btnSelectFriend').click(function() {
                    $('#selectedUserId').val($(this).attr('mixi-id'));
                    $('#selectedUserImg').attr('src', $(this).attr('mixi-img'));
                });
            });
        });

        var postCallback = function(data) {
            if (data.error) {
                qs.dialog.showMsg('Error', data.error);
            }
            else {
                qs.dialog.showMsg('Success', '完了しました');
            }
        };

    }


init();
qs.api.lookupProfile(function(data) {
    setButtonsEvents(data.entry);
    $('#display').html($('#tmplMenu').tmpl());
    mixi.window.adjustHeight();
});

});
