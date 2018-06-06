# nusic
Simple music playing iOS application.  
Play music from playlists, artists, albums, songs.  
Prepare shuffle mode for each, also support background playback and control from the control center.  
<br />
シンプルなiOS音楽再生アプリ  
プレイリスト、アーティスト、アルバム、曲から音楽を再生  
それぞれにシャッフルモードを用意、バックグラウンド再生やコントロールセンターからの操作にも対応

# Postscript 7/6/2018
Off timer function added, time can be set (0.5H-3.0H) from button long press.  
Measure continues even in the background, music stopped automatically.  
<br />
切タイマー機能を追加し、ボタン長押しから時間設定が可能(0.5H-3.0H)  
バックグラウンドでも計測し続け、自動で音楽停止

# Fairy's mischief
Sometimes the song that is different from the selected song is played.  
Since there is no problem with item selection, there is a possibility that data cache by singleton is involved.  
Frequent occurrence when shuffle mode is changed.  
<br />
たまに選択した曲と異なる曲が再生される  
アイテム選択に問題はないのでシングルトン周りのキャッシュが絡んでいる可能性  
シャッフルモードを変更すると頻発

# Dependency
Xcode 8.3.3  
Swift 3.1

# License
This software is released under the MIT License, see LICENSE.

# Authors
SYOTA TSUDA  
http://dokonoko.pinoko.jp/project/
