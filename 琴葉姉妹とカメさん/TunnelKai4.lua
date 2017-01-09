----------------------
--自動トンネル建設 改
----------------------

ARGS={...} --コマンドライン引数を取得（タートルの位置設定用、最上段は1、最下段は2、最下段から2番目は3）
locate=ARGS[1] --1つだけ使う

--何は扨措き定数設定
locateUp="1" --タートルの位置設定 最上段
locateDown="2" --タートルの位置設定 最下段
locateDown2="3" --タートルの位置設定 最下段から二番目

FuelLimit=10 --燃料下限値
Box0=14 --ガラス持ってるインベントリのインデックス（初期位置）
BoxMax=16 --ガラス持ってるインベントリのインデックス（限界位置）
Light=13 --グロウストーン持ってるインベントリのインデックス
RedStone=13 --レッドストーンブロック持ってるインベントリのインデックス
Stone=12 --丸石持ってるインベントリのインデックス
Rail=13 --レール持ってるインベントリのインデックス
PoweredRail=12 --パワードレール持ってるインベントリのインデックス
LightRangeMax=6 --グロウストーンを置く間隔
PoweredRailRangeMax=32 --パワードレールを置く間隔


--水もしくは溶岩の検知
--inspect()で得たテーブルを引数として渡す。
--返り値は水or溶岩ならtrue,それ以外はfalse
function checkWaters(table)
	local bool=false
	if string.find(table["name"],"water") or string.find(table["name"],"lava") then
		bool=true
	end
	return bool
end

--ガラスを設置しようとする前に在庫確認
function putBox()
	if turtle.getItemCount(box)==0 then --現在選択中のガラスインベントリに在庫がないかどうか
		--ガラスないっす
		if box==BoxMax then --それが最後のガラスインベントリかどうか
			--最後の一つは無くなりました。
			print("GarasuNai") --すぐ入れるね。ちょっと待ってね。
			while turtle.getItemCount(box)==0 do --ガラスを入れてもらえるまで待機
				sleep(0)
			end
			box=Box0 --選択中のガラスインベントリを移動
		else
			--まだ次があるさー
			box=box+1 --次のガラスインベントリを選択
		end
	end
	turtle.select(box) --ガラスインベントリを選択
end

--ブロックを設置しようとする前に在庫確認（ガラス以外）
function putCheck(itemIndex)
	if turtle.getItemCount(itemIndex)==0 then --インベントリに在庫がない
		print("AitemuNai",itemIndex) --お願いします待ってください何でもしますから
		while turtle.getItemCount(itemIndex)==0 do --アイテムを入れてもらえるまで待機
			sleep(0)
		end
	end
	turtle.select(itemIndex) --対象インベントリを選択
end

--レール設置前にブロックがあるかを確認
--あれば除去（タートルは無視）
function digDownRail()
	local bool,table=turtle.inspectDown()
	if bool then
		while not string.find(table["name"],"Turtle") do
			turtle.digDown()
			bool,table=turtle.inspectDown()
			if not bool then
				break
			end
		end
	end
end
---------------------------
--メインループううううあああああああああ
---------------------------

--変数の初期化
lightRange=LightRangeMax --松明置く間隔を数えるための変数
powerRailRange=PoweredRailRangeMax --松明置く間隔を数えるための変数
box=Box0 --現在のガラスインベントリを表す変数、はじめは初期ガラスインベントリに設定
turtle.select(box) --ガラスインベントリを選択
locateBefore=true

--ループ突入
while true do

	--燃料の確認
	if turtle.getFuelLevel()<FuelLimit then --燃料が上限値未満かどうか
		print("HaragaHettehaIkusahaDekinu")	--お待ちくだせぇ
		while turtle.getFuelLevel()<FuelLimit do --燃料補給まで待機(インベントリ1にある燃料を消費する)
			sleep(0)
			turtle.select(1)
			turtle.refuel()
		end
	end

	--各種一定間隔ブロックの設置処理（スタート時に1個設置して、そこから数える）

	--グロウストーン処理
	if string.find(locate,locateUp) then --最上段タートルのみ実行
		lightRange=lightRange+1 --前に進んだらグロウストーン間隔を数える変数に+1
		if lightRange>=LightRangeMax then --グロウストーン設置間隔以上も離れた
			--グロウストーンを設置
			putCheck(Light) --アイテムを設置しようとする独自関数
			if turtle.detectUp() then
				while not turtle.digUp() do
					sleep(0)
				end
			end
			while not turtle.placeUp() do
				sleep(0)
			end
			print("Akaruiyaro Homero") --偉いぞ
			--ガラスインベントリを選択
			turtle.select(box)
			--間隔を数える変数を0に
			lightRange=0
		end
	end

	--レッドストーン処理
	if string.find(locate,locateDown) then --最下段タートルのみ実行
		powerRailRange=powerRailRange+1 --前に進んだらパワードレールの間隔を数える変数に+1
		if powerRailRange>=PoweredRailRangeMax then --パワードレール設置間隔以上も離れた
			--レッドストーンを設置
			putCheck(RedStone) --アイテムを設置しようとする独自関数
			turtle.digDown()
			turtle.placeDown()
			print("Oitade Homero") --偉いぞ
			--ガラスインベントリを選択
			turtle.select(box)
			--間隔を数える変数を0に
			powerRailRange=0
		end
	end

	--パワードレール・レール処理
	if string.find(locate,locateDown2) then --最下段から2番目タートルのみ実行
		powerRailRange=powerRailRange+1 --前に進んだらパワードレールの間隔を数える変数に+1
		if powerRailRange>=PoweredRailRangeMax then --パワードレール設置間隔以上も離れた
			--パワードレールを設置（置けるまで試行し続ける）
			putCheck(PoweredRail) --アイテムを設置しようとする独自関数
			digDownRail() --レール設置前に下のブロックを確認
			while turtle.placeDown() do
				sleep(0)
			end
			print("Oitade Homero") --偉いぞ
			--ガラスインベントリを選択
			turtle.select(box)
			--間隔を数える変数を0に
			powerRailRange=0
		else
			--レールを設置（置けるまで試行し続ける）
			putCheck(Rail) --アイテムを設置しようとする独自関数
			digDownRail()
			while turtle.placeDown() do
				sleep(0)
			end
			--ガラスインベントリを選択
			turtle.select(box)
		end
	end


	--ここから始まるトンネル建設処理

	--上面
	if string.find(locate,locateUp) then --タートル位置最上段なら実行
		if not turtle.detectUp() then --上にブロックが無ければガラスを設置
			putBox() --ガラスを設置しようとする独自関数
			turtle.placeUp()
		end
	end

	--下面
	if string.find(locate,locateDown) then --タートル位置最下段なら実行
		if not turtle.detectDown() then --下にブロックが無ければ丸石を設置
			putCheck(Stone)
			turtle.placeDown()
		end
	end

	--以下共通処理

	--右面
	--右を向いて空洞確認
	turtle.turnRight()
	if not turtle.detect() then --右にブロックがが無ければガラスを設置
		putBox()
		turtle.place()
		print("Essa") --えっさ
	end
	turtle.turnLeft()

	--左面
	--左を向いて空洞確認
	turtle.turnLeft()
	if not turtle.detect() then --左にブロックがが無ければガラスを設置
		putBox()
		turtle.place()
		print("Hossa") --ほっさ
	end
	turtle.turnRight()

	--正面

	--水漏れチェック
	--上面に液体があるかを確認
	bool1,table1=turtle.inspectUp() --上面ブロック詳細確認
	if bool1 then --何かがあるかどうか
		while checkWaters(table1) do --液体であれば待機
			sleep(1) --なんとなくの1秒
			bool1,table1=turtle.inspectUp() --もっかい調べる
			if not bool1 then --空洞になったら再稼働
				break
			end
		end
	end
	--下面に水があるかを確認,上面と一緒
	bool1,table1=turtle.inspectDown() --下面ブロック詳細確認
	if bool1 then
		while checkWaters(table1) do
			sleep(1)
			bool1,table1=turtle.inspectDown()
			if not bool1 then
				break
			end
		end
	end

	--掘り進めええええええ
	while turtle.detect() do --ブロックがあれば掘削
		turtle.dig()
	end
	--前進(成功するまで進む)
	while not turtle.forward() do
		sleep(0)
	end

end