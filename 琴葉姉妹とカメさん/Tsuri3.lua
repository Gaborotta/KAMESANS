turtle.select(1) --選択インベントリを左上にする
while true do --無限ループ
	turtle.select(1) --一応もう一回インベントリを左上
	bool=turtle.attack() --釣り糸を垂らす
	print("Turude",bool)
	sleep(40) --40秒待機
	bool=turtle.dig() --釣り上げる
	if bool then --釣れたか判定
		--釣れたで
		print("Tuttade Homero") --すごいよカメさん
		turtle.select(1)
		table=turtle.getItemDetail(1) --釣ったアイテムの詳細確認
		if string.find(table["name"],"fish") then --魚かどうか
			if table["damage"]==0 or table["damage"]== 1 then --普通の魚もしくは鮭かどうか
				turtle.dropDown() --食べれる魚は下にいるタートルに渡す
			else
				turtle.dropUp() --食べれない魚は上のチェストに
			end
		else
			turtle.dropUp() --食べれない物は上のチェストに
		end
	else
		--釣れへんかったで
		print("Tsurehenkatta Gomennaa") --ええんやで
	end
	sleep(0) --バグ回避
end

