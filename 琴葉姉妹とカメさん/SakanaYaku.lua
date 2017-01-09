turtle.select(1) --インベントリ左上選択
while true do
	for i=1,8 do --インベントリの一番上8個に入ってるアイテム対象
		if turtle.getItemCount(i)>=8 then --魚が8匹以上になったらかまどに入れる
			print("SakanaYakude")
			turtle.select(i) --かまどに入らなかったら次を試す
			count=turtle.getItemCount(i)-turtle.getItemCount(i)%8 --投入数を8の倍数に調整
			if turtle.dropDown(count) then --かまどに魚を入れようとする
				print("Iretade") --偉いぞ
			else
				print("Hairankatta") --次試そうな
			end
		end
	end
	--全部試したらちょっと待機
	print("ChottoMatsude")--OK
	sleep(80) --木炭1個分の燃焼時間待つ
end
