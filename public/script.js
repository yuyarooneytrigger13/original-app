const TILE_SIZE = 40;
const GAP = 4;

const PREFECTURES = [
  // 北海道・東北
    { id: 1, name: '北海道', row: 1, col: 11, w: 2, h: 2 },
    { id: 2, name: '青森',   row: 3, col: 11 },
    { id: 3, name: '岩手',   row: 4, col: 12 },
    { id: 4, name: '宮城',   row: 5, col: 12 },
    { id: 5, name: '秋田',   row: 4, col: 11 },
    { id: 6, name: '山形',   row: 5, col: 11 },
    { id: 7, name: '福島',   row: 6, col: 11 },
    
    // 関東
    { id: 8, name: '茨城',   row: 7, col: 12 },
    { id: 9, name: '栃木',   row: 7, col: 11 },
    { id: 10, name: '群馬',  row: 7, col: 10 },
    { id: 11, name: '埼玉',  row: 8, col: 10 },
    { id: 12, name: '千葉',  row: 8, col: 11 },
    { id: 13, name: '東京',  row: 9, col: 10 },
    { id: 14, name: '神奈川', row: 9, col: 11 },

    // 中部
    { id: 15, name: '新潟',  row: 6, col: 10 },
    { id: 16, name: '富山',  row: 6, col: 9 },
    { id: 17, name: '石川',  row: 5, col: 8 },
    { id: 18, name: '福井',  row: 6, col: 8 },
    { id: 19, name: '山梨',  row: 8, col: 9 },
    { id: 20, name: '長野',  row: 7, col: 9 },
    { id: 21, name: '岐阜',  row: 7, col: 8 },
    { id: 22, name: '静岡',  row: 9, col: 9 },
    { id: 23, name: '愛知',  row: 8, col: 8 },

    // 近畿
    { id: 24, name: '三重',  row: 9, col: 7 },
    { id: 25, name: '滋賀',  row: 7, col: 7 },
    { id: 26, name: '京都',  row: 7, col: 6 },
    { id: 27, name: '大阪',  row: 8, col: 6 },
    { id: 28, name: '兵庫',  row: 7, col: 5 },
    { id: 29, name: '奈良',  row: 8, col: 7 },
    { id: 30, name: '和歌山', row: 9, col: 6 },

    // 中国
    { id: 31, name: '鳥取',  row: 7, col: 4 },
    { id: 32, name: '島根',  row: 7, col: 3 },
    { id: 33, name: '岡山',  row: 8, col: 4 },
    { id: 34, name: '広島',  row: 8, col: 3 },
    { id: 35, name: '山口',  row: 8, col: 2 },

    // 四国
    { id: 36, name: '徳島',  row: 10, col: 5 },
    { id: 37, name: '香川',  row: 10, col: 4 },
    { id: 38, name: '愛媛',  row: 10, col: 3 },
    { id: 39, name: '高知',  row: 11, col: 4 },

    // 九州・沖縄
    { id: 40, name: '福岡',  row: 8, col: 1 },
    { id: 41, name: '佐賀',  row: 8, col: 0 },
    { id: 42, name: '長崎',  row: 9, col: 0 },
    { id: 43, name: '熊本',  row: 9, col: 1 },
    { id: 44, name: '大分',  row: 9, col: 2 },
    { id: 45, name: '宮崎',  row: 10, col: 2 },
    { id: 46, name: '鹿児島', row: 10, col: 1 },
    { id: 47, name: '沖縄',  row: 12, col: 0 },
];

let visitedData = {};
let currentPrefId = null;

document.addEventListener('turbo:load', () => {
    renderMap();
    fetchMapData();
    if (window.lucide) {
        window.lucide.createIcons();
    }
});

function renderMap() {
    const svg = document.getElementById('japan-map');
    if (!svg) return;
    svg.innerHTML = ''; 

    const svgNS = "http://www.w3.org/2000/svg";

    PREFECTURES.forEach(pref => {
      const g = document.createElementNS(svgNS, 'g');
      g.setAttribute('class', 'pref-group');
      g.setAttribute('data-id', pref.id);
      g.onclick = () => openModal(pref);

        // 座標の計算
      const x = pref.col * (TILE_SIZE + GAP) + 50;
      const y = pref.row * (TILE_SIZE + GAP);
      const w = (pref.w || 1) * TILE_SIZE + ((pref.w || 1) - 1) * GAP;
      const h = (pref.h || 1) * TILE_SIZE + ((pref.h || 1) - 1) * GAP;

        // 四角形タイル
      const rect = document.createElementNS(svgNS, 'rect');
        rect.setAttribute('x', x);
        rect.setAttribute('y', y);
        rect.setAttribute('width', w);
        rect.setAttribute('height', h);
        rect.setAttribute('rx', 6);
        rect.setAttribute('class', 'pref-tile');
        rect.setAttribute('id', `rect-${pref.id}`);

        // 都道府県名テキスト
        const text = document.createElementNS(svgNS, 'text');
        text.setAttribute('x', x + w / 2);
        text.setAttribute('y', y + h / 2 + 4);
        text.setAttribute('class', 'pref-label');
        text.setAttribute('id', `text-${pref.id}`);
        text.textContent = pref.name;

        g.appendChild(rect);
        g.appendChild(text);
        svg.appendChild(g);
    });
}

    function openModal(pref) {
    currentPrefId = pref.id;
    document.getElementById('modal-title').textContent = pref.name;
    document.getElementById('modal').classList.add('active');

    const data = visitedData[pref.id];
    const deleteBtn = document.getElementById('btn-delete');
    const imageInput = document.getElementById('input-image');
    
    if (data) {
        document.getElementById('input-date').value = data.date;
        document.getElementById('input-memo').value = data.memo;
        if (imageInput) imageInput.value = ''; // 入力リセット
        deleteBtn.style.visibility = 'visible';
    } else {
        document.getElementById('input-date').value = '';
        document.getElementById('input-memo').value = '';
        if (imageInput) imageInput.value = ''; // 入力リセット
        deleteBtn.style.visibility = 'hidden';
    }
}

function closeModal() {
    document.getElementById('modal').classList.remove('active');
    currentPrefId = null;
}

async function fetchMapData() {
    const token = document.querySelector('meta[name="csrf-token"]');
    if (!token) return; 

    try {
        const response = await fetch('/visited_records.json');
        if (response.ok) {
            const data = await response.json();
            visitedData = {};
            data.forEach(record => {
                visitedData[record.prefecture] = {
                    visited: true,
                    date: record.visited_date,
                    memo: record.review
                };
            });
            updateUI();
        }
    } catch (e) {
        console.error(e);
    }
}

async function saveRecord() {
    if (!currentPrefId) return;
    const date = document.getElementById('input-date').value;
    const memo = document.getElementById('input-memo').value;
    const imageInput = document.getElementById('input-image');
    
    const token = document.querySelector('meta[name="csrf-token"]').content;
    
    const formData = new FormData();
    formData.append('visited_record[prefecture]', currentPrefId);
    formData.append('visited_record[visited_date]', date);
    formData.append('visited_record[review]', memo);
    if (imageInput && imageInput.files[0]) {
        formData.append('visited_record[image]', imageInput.files[0]);
    }

    const response = await fetch('/visited_records', {
        method: 'POST',
        headers: {
            'X-CSRF-Token': token
        },
        body: formData
    });

    if (response.ok) {
        visitedData[currentPrefId] = { visited: true, date, memo };
        updateUI();
        closeModal();
    }
}

async function deleteRecord() {
    if (!currentPrefId) return;
    
    const token = document.querySelector('meta[name="csrf-token"]').content;
    const response = await fetch(`/visited_records/${currentPrefId}`, {
        method: 'DELETE',
        headers: {
            'X-CSRF-Token': token
        }
    });
    if (response.ok) {
        delete visitedData[currentPrefId];
        updateUI();
        closeModal();
    }
}

function updateUI() {
    PREFECTURES.forEach(pref => {
        const rect = document.getElementById(`rect-${pref.id}`);
        const text = document.getElementById(`text-${pref.id}`);
        if (visitedData[pref.id]) {
            rect.classList.add('visited');
            text.classList.add('visited-text');
        } else {
            rect.classList.remove('visited');
            text.classList.remove('visited-text');
        }
    });
    
    updateStats();

   // リストの更新
    const listEl = document.getElementById('memory-list');
    if (listEl) {
        listEl.innerHTML = '';
        
        const records = Object.entries(visitedData);
        if(records.length === 0) {
            const emptyDiv = document.createElement('div');
            emptyDiv.className = 'empty-state';
            emptyDiv.textContent = 'まだ記録がありません';
            listEl.appendChild(emptyDiv);
        } else {
            records.forEach(([id, data]) => {
                const pref = PREFECTURES.find(p => p.id == id);
                const div = document.createElement('div');
                div.className = 'memory-card';
                div.innerHTML = `
                    <div class="memory-header">${pref.name}</div>
                    <div class="memory-date">${data.date}</div>
                    <div class="memory-text">${data.memo}</div>
                `;
                listEl.appendChild(div);
            });
        }
    }
}

function updateStats() {
    const count = Object.keys(visitedData).length;
    const rate = Math.round((count / 47) * 100);
    
    const countEl = document.getElementById('visited-count');
    const rateEl = document.getElementById('visited-rate');
    
    if (countEl) countEl.textContent = count;
    if (rateEl) rateEl.textContent = `${rate}%`;
}

window.closeModal = closeModal;
window.saveRecord = saveRecord;
window.deleteRecord = deleteRecord;
