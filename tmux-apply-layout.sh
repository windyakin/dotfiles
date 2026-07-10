#!/bin/sh
# tmux-apply-layout.sh
# ペイン数に応じたレイアウトを適用し、ペイン番号が位置順になるよう並べ替える

panes=$(tmux display-message -p '#{window_panes}')

# tmux レイアウト文字列のチェックサムを計算する
layout_checksum() {
  printf '%s' "$1" | perl -ne '
    my $csum = 0;
    for my $c (split //, $_) {
      $csum = ($csum >> 1) + (($csum & 1) << 15);
      $csum += ord($c);
      $csum &= 0xFFFF;
    }
    printf "%04x", $csum;
  '
}

# レイアウト適用
if [ "$panes" -eq 2 ]; then
  tmux select-layout even-horizontal

elif [ "$panes" -eq 3 ]; then
  # トグル動作: 右側上下分割 ↔ 左側上下分割
  W=$(tmux display-message -p '#{window_width}')
  H=$(tmux display-message -p '#{window_height}')
  w1=$((W / 2))
  w2=$((W - w1 - 1))
  h1=$((H / 2))
  h2=$((H - h1 - 1))
  x2=$((w1 + 1))
  y2=$((h1 + 1))

  ids=$(tmux list-panes -F '#{pane_index} #{pane_id}' | sort -k1,1n | sed 's/.*%//')
  id1=$(echo "$ids" | sed -n '1p')
  id2=$(echo "$ids" | sed -n '2p')
  id3=$(echo "$ids" | sed -n '3p')

  # 左側(pane_left==0)のペイン数で現在のレイアウトを判定
  left_count=$(tmux list-panes -F '#{pane_left}' | awk '$1==0' | wc -l | tr -d ' ')

  if [ "$left_count" -eq 1 ]; then
    # 現在: 1|2  → 切替: 1|3
    #       |--          --|
    #       |3           2|
    body="${W}x${H},0,0{${w1}x${H},0,0[${w1}x${h1},0,0,${id1},${w1}x${h2},0,${y2},${id2}],${w2}x${H},${x2},0,${id3}}"
  else
    # 現在: 左分割 or 初回 → 右分割に
    # 1|2
    #  |--
    #  |3
    body="${W}x${H},0,0{${w1}x${H},0,0,${id1},${w2}x${H},${x2},0[${w2}x${h1},${x2},0,${id2},${w2}x${h2},${x2},${y2},${id3}]}"
  fi

  csum=$(layout_checksum "$body")
  tmux select-layout "${csum},${body}"

elif [ "$panes" -eq 4 ]; then
  # カスタムレイアウト: 左右分割 → 各列を上下分割
  # 1 | 3
  # --+--
  # 2 | 4
  W=$(tmux display-message -p '#{window_width}')
  H=$(tmux display-message -p '#{window_height}')
  w1=$((W / 2))
  w2=$((W - w1 - 1))
  h1=$((H / 2))
  h2=$((H - h1 - 1))
  x2=$((w1 + 1))
  y2=$((h1 + 1))

  # ペインIDをインデックス順に取得（%を除去した数値）
  ids=$(tmux list-panes -F '#{pane_index} #{pane_id}' | sort -k1,1n | sed 's/.*%//')
  id1=$(echo "$ids" | sed -n '1p')
  id2=$(echo "$ids" | sed -n '2p')
  id3=$(echo "$ids" | sed -n '3p')
  id4=$(echo "$ids" | sed -n '4p')

  body="${W}x${H},0,0{${w1}x${H},0,0[${w1}x${h1},0,0,${id1},${w1}x${h2},0,${y2},${id2}],${w2}x${H},${x2},0[${w2}x${h1},${x2},0,${id3},${w2}x${h2},${x2},${y2},${id4}]}"
  csum=$(layout_checksum "$body")
  tmux select-layout "${csum},${body}"

elif [ "$panes" -ge 5 ]; then
  tmux select-layout tiled
fi

# ペイン番号が位置順（左上→右下）に一致するよう swap-pane で並べ替え
i=1
while [ "$i" -le "$panes" ]; do
  pos_id=$(tmux list-panes -F '#{pane_left} #{pane_top} #{pane_id}' | sort -k1,1n -k2,2n | awk "NR==$i{print \$3}")
  idx_id=$(tmux list-panes -F '#{pane_index} #{pane_id}' | sort -k1,1n | awk "NR==$i{print \$2}")
  if [ "$pos_id" != "$idx_id" ]; then
    tmux swap-pane -d -s "$pos_id" -t "$idx_id"
  fi
  i=$((i + 1))
done
