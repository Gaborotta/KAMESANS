--定数
naegiMin=21 --苗木必要数（植えた木の本数)
fuelMin=500 --燃料最低ライン(てきとー)

--レッドストーントーチあたり判定（下にあるとき）
function DetectRedStoneDown()
	bool2,table2=turtle.inspectDown() --下にあるブロックの詳細確認
	if bool2 and string.find(table2["name"],"redstone") then --レッドストーン関連かどうか
		--レッドストーン関連やった
		print("KonoShitaRedStoneYawa") --曲がってな
		turtle.back()
		DetectRedStone(i) --レッドストーンに当たった時の処理
		turtle.forward()
	end
	turtle.down() --レッドストーンでも違うくても降りる
end

--レッドストーントーチに当たった時の処理
function DetectRedStone()
	i=i+1 --レッドストーンに当たった回数を増やす
	print(i,"KaiAtattade")
	if i==1 or i==2 or i==7 then --1,2,7回目は右に曲がる、それ以外は左
		turtle.turnRight()
	else
		turtle.turnLeft()
	end
end

--メインループ
i=0 --レッドストーントーチに当たった回数を数える
while true do
sleep(0)
turtle.select(1) --インベントリ左上選択
	if turtle.detect() then --何かに当たったかどうか
		--何かに当たった
		print("NankaAtattade") --カメさん大丈夫？
		bool,table=turtle.inspect() --当たったブロックの詳細確認

		if string.find(table["name"],"redstone") then --レッドストーン関連かどうか
			print("RedStoneYawa") --曲がってな
			DetectRedStone() --レッドストーンに当たった時の処理をする関数を実行

		elseif string.find(table["name"],"chest") then --チェストかどうか
			print("ChestYa")
			print("Simaude") --偉いぞ
			for k=1,5 do --1～5番目のインベントリが対象
				turtle.select(k)
				turtle.drop() --しまう
			end
			turtle.select(1) --インベントリ左上選択
			turtle.suck() --チェストの左上（苗木）から1スタック取り出す
			--初期位置に戻す
			turtle.turnRight()
			turtle.turnRight()
			i=0
			print("Matsude") --OK
			sleep(600) --とりあえず10分放置
			if  turtle.getItemCount(1)<naegiMin then --苗木が十分な数あるかどうか
				print("NaegiKureya") --ちょっと待ってな、すぐ入れるから
				while turtle.getItemCount(1)<naegiMin do --苗木入れられるまで待機
					sleep(0)
				end
				print("OKyade") --ごめんな
			end
			if turtle.getFuelLevel() <fuelMin then --燃料が十分かどうか
				--十分じゃない
				print("NenryouKureyo") --チェストに入ってるで
				--木炭チェストまで移動
				turtle.turnRight()
				turtle.forward()
				turtle.turnRight()
				turtle.forward()
				while turtle.getFuelLevel() <fuelMin do --燃料が十分になるまで補給し続ける
					turtle.suck()
					turtle.select(2)
					turtle.refuel()
					sleep(0)
				end
				--補給完了
				print("OKyade") --偉いぞ
				--初期位置に戻る
				turtle.turnRight()
				turtle.turnRight()
				turtle.forward()
				turtle.turnLeft()
				turtle.forward()
				turtle.turnRight()
				turtle.select(1)
			end

		elseif string.find(table["name"],"sapling") then --苗木かどうか
			--苗木でした
			print("NaegiYa") --避けてな
			--上に移動して避ける
			turtle.up()
			turtle.forward()
			turtle.forward()
			DetectRedStoneDown() --このとき下にレッドストーンがある可能性があるのでチェック

		else --それ以外（木のはず）
			--伐採開始
			print("Kirude") --頼んだぞ
			turtle.dig() --切って
			turtle.forward() --一歩進んで
			while turtle.detectUp() do --上にブロックがあれば切って昇る
				turtle.digUp()
				turtle.up()
			end
			--頂上到達
			print("w") --カメさん、それ草やない。葉っぱや。
			while not turtle.detectDown() do --地面に当たるまで降下し続ける
				turtle.down()
			end
			--苗木を植える
			print("Uerude") --苗木植えるカメさん可愛い
			turtle.up()
			turtle.placeDown()
			turtle.forward()
			DetectRedStoneDown() --このとき下にレッドストーンがある可能性があるのでチェック
		end

	else
		--何にも当たってなければそのまま前進
		turtle.forward()
	end
end