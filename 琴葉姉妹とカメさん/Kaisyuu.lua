--定数
fuelMin=100

i=0 --壁に当たった回数をカウント
while true do
	sleep(0)
	turtle.forward() --前に進んで
	turtle.suck() --落ちてるアイテムを拾う
	if turtle.detect() then --壁に当たった
		--壁に当たったカウントを進めて回転
		i=i+1
		turtle.turnRight()
		turtle.turnRight()

		if i%2==0 and turtle.getItemCount(1)>10 then --初期位置に戻ってきた時に苗木を10個以上持ってるかどうか
			--苗木が貯まってたらチェストに移動
			--チェストに向けて移動
			print("ShimainiIkude") --気を付けてな
			turtle.turnRight()
			turtle.up()
			for j=1,11 do
				turtle.forward()
			end
			turtle.turnLeft()
			turtle.forward()
			--チェスト前に到着

			--苗木をチェストに収納
			turtle.select(1)
			turtle.drop()
			print("Simattade Homero") --偉いぞ

			--ついでに燃料の確認
			if turtle.getFuelLevel() <fuelMin then --燃料が十分かどうか
				--十分じゃない
				print("NenryouKureyo") --チェストに入ってるで
				--木炭チェストまで移動
				turtle.turnRight()
				turtle.forward()
				turtle.turnLeft()
				turtle.forward()
				while turtle.getFuelLevel() <fuelMin do --燃料が十分になるまで補給し続ける
					turtle.suck()
					turtle.select(2)
					turtle.refuel()
					sleep(0)
				end
				--補給完了
				print("OKyade") --偉いぞ
				--戻る
				turtle.back()
				turtle.turnRight()
				turtle.back()
				turtle.turnLeft()
				turtle.select(1)
			end

			--初期位置に戻る
			turtle.turnRight()
			turtle.turnRight()
			turtle.forward()
			turtle.turnRight()
			for j=1,11 do
				turtle.forward()
			end
			turtle.down()
			turtle.turnRight()

			--初期位置に戻ってきた
			print("ChottoMatsude") --ゆっくりしていってね！
			sleep(300) --5分待機
		end
		sleep(10) --壁に当たったら10秒待機
	end
end
