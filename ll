<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>车流密集 - 过马路模拟器</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        road: {
                            asphalt: '#333333',
                            line: '#ffffff',
                            sidewalk: '#8B4513',
                            grass: '#228B22'
                        },
                        player: '#FFD700',
                        car: {
                            red: '#FF3B30',
                            blue: '#007AFF',
                            yellow: '#FFCC00',
                            black: '#111111'
                        }
                    },
                    fontFamily: {
                        game: ['"Comic Sans MS"', '"Chalkboard SE"', 'sans-serif']
                    }
                }
            }
        }
    </script>
    <style type="text/tailwindcss">
        @layer utilities {
            .game-shadow {
                box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.3);
            }
            .pulse-effect {
                animation: pulse 1.5s infinite;
            }
            .bounce-once {
                animation: bounce 0.5s ease-in-out;
            }
            .slide-in {
                animation: slideIn 0.5s ease-out forwards;
            }
            .shake {
                animation: shake 0.5s cubic-bezier(.36,.07,.19,.97) both;
            }
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        
        @keyframes shake {
            10%, 90% { transform: translateX(-1px); }
            20%, 80% { transform: translateX(2px); }
            30%, 50%, 70% { transform: translateX(-3px); }
            40%, 60% { transform: translateX(3px); }
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-100 to-gray-200 min-h-screen flex flex-col items-center justify-center p-4 font-game">
    <div class="text-center mb-4">
        <h1 class="text-[clamp(1.8rem,5vw,3rem)] font-bold text-gray-800 mb-2">
            <i class="fa fa-road text-road-asphalt mr-2"></i>车流密集 - 过马路模拟器
        </h1>
        <p class="text-gray-600 text-sm md:text-base">车辆更多，挑战升级！小心穿过马路</p>
    </div>
    
    <div class="relative w-full max-w-md">
        <!-- 游戏容器 -->
        <div class="game-shadow rounded-lg overflow-hidden bg-road-asphalt">
            <!-- 游戏画布 -->
            <canvas id="gameCanvas" class="w-full"></canvas>
            
            <!-- 开始界面 -->
            <div id="startScreen" class="absolute inset-0 bg-black/70 flex flex-col items-center justify-center z-10">
                <div class="text-center p-6 bg-white/10 backdrop-blur-sm rounded-xl slide-in">
                    <div class="text-6xl mb-4 text-player">
                        <i class="fa fa-male"></i>
                    </div>
                    <h2 class="text-2xl font-bold text-white mb-2">密集车流挑战</h2>
                    <p class="text-gray-300 mb-6">车辆数量大幅增加，谨慎移动躲避车辆</p>
                    <button id="startButton" class="bg-player hover:bg-yellow-400 text-gray-800 font-bold py-3 px-8 rounded-full transition-all pulse-effect">
                        开始游戏
                    </button>
                </div>
            </div>
            
            <!-- 游戏结束界面 -->
            <div id="gameOverScreen" class="absolute inset-0 bg-black/70 flex flex-col items-center justify-center z-10 hidden">
                <div class="text-center p-6 bg-white/10 backdrop-blur-sm rounded-xl">
                    <h2 class="text-2xl font-bold text-red-500 mb-2">游戏结束!</h2>
                    <p class="text-white text-xl mb-2">你的得分: <span id="finalScore" class="text-player">0</span></p>
                    <p class="text-white text-xl mb-6">最高记录: <span id="highScore" class="text-green-400">0</span></p>
                    <button id="restartButton" class="bg-player hover:bg-yellow-400 text-gray-800 font-bold py-3 px-8 rounded-full transition-all pulse-effect">
                        再来一次
                    </button>
                </div>
            </div>
            
            <!-- 得分显示 -->
            <div id="scoreDisplay" class="absolute top-4 left-4 bg-black/50 text-white px-3 py-1 rounded-full text-lg font-bold z-5 hidden">
                得分: <span id="score" class="text-player">0</span>
            </div>
            
            <!-- 级别显示 -->
            <div id="levelDisplay" class="absolute top-4 right-4 bg-black/50 text-white px-3 py-1 rounded-full text-lg font-bold z-5 hidden">
                级别: <span id="level" class="text-green-400">1</span>
            </div>
        </div>
        
        <!-- 移动设备控制按钮 -->
        <div class="mt-4 grid grid-cols-3 gap-2 max-w-xs mx-auto">
            <div class="col-start-2">
                <button id="btnUp" class="w-full aspect-square bg-gray-700/80 hover:bg-gray-600 text-white rounded-lg flex items-center justify-center">
                    <i class="fa fa-arrow-up text-xl"></i>
                </button>
            </div>
            <div class="col-start-1">
                <button id="btnLeft" class="w-full aspect-square bg-gray-700/80 hover:bg-gray-600 text-white rounded-lg flex items-center justify-center">
                    <i class="fa fa-arrow-left text-xl"></i>
                </button>
            </div>
            <div class="col-start-2">
                <button id="btnDown" class="w-full aspect-square bg-gray-700/80 hover:bg-gray-600 text-white rounded-lg flex items-center justify-center">
                    <i class="fa fa-arrow-down text-xl"></i>
                </button>
            </div>
            <div class="col-start-3">
                <button id="btnRight" class="w-full aspect-square bg-gray-700/80 hover:bg-gray-600 text-white rounded-lg flex items-center justify-center">
                    <i class="fa fa-arrow-right text-xl"></i>
                </button>
            </div>
        </div>
    </div>
    
    <!-- 游戏说明 -->
    <div class="mt-6 text-center max-w-md text-gray-600 text-sm">
        <p><i class="fa fa-info-circle mr-1"></i> 游戏说明: 车辆数量大幅增加，每成功过马路一次得分增加10分，级别越高挑战越大</p>
    </div>
    
    <!-- 游戏音效 -->
    <audio id="soundStart" preload="auto">
        <source src="https://assets.mixkit.co/sfx/preview/mixkit-game-start-610.mp3" type="audio/mpeg">
    </audio>
    <audio id="soundScore" preload="auto">
        <source src="https://assets.mixkit.co/sfx/preview/mixkit-arcade-coin-collect-193.mp3" type="audio/mpeg">
    </think>
    <audio id="soundHit" preload="auto">
        <source src="https://assets.mixkit.co/sfx/preview/mixkit-player-losing-or-failing-2042.mp3" type="audio/mpeg">
    </think>
    <audio id="soundLevelUp" preload="auto">
        <source src="https://assets.mixkit.co/sfx/preview/mixkit-achievement-bell-600.mp3" type="audio/mpeg">
    </think>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            // 获取画布和上下文
            const canvas = document.getElementById('gameCanvas');
            const ctx = canvas.getContext('2d');
            
            // 游戏元素
            const startScreen = document.getElementById('startScreen');
            const gameOverScreen = document.getElementById('gameOverScreen');
            const startButton = document.getElementById('startButton');
            const restartButton = document.getElementById('restartButton');
            const scoreDisplay = document.getElementById('scoreDisplay');
            const levelDisplay = document.getElementById('levelDisplay');
            const scoreElement = document.getElementById('score');
            const finalScoreElement = document.getElementById('finalScore');
            const highScoreElement = document.getElementById('highScore');
            const levelElement = document.getElementById('level');
            
            // 控制按钮
            const btnUp = document.getElementById('btnUp');
            const btnDown = document.getElementById('btnDown');
            const btnLeft = document.getElementById('btnLeft');
            const btnRight = document.getElementById('btnRight');
            
            // 音效元素
            const sounds = {
                start: document.getElementById('soundStart'),
                score: document.getElementById('soundScore'),
                hit: document.getElementById('soundHit'),
                levelUp: document.getElementById('soundLevelUp')
            };
            
            // 游戏配置 - 增加了车辆数量
            const GAME_WIDTH = 400;
            const GAME_HEIGHT = 600;
            const LANES = 5; // 车道数量
            const PLAYER_SIZE = 30;
            const CAR_SIZES = [
                { width: 50, height: 30 },  // 小型车
                { width: 70, height: 35 },  // 中型车
                { width: 90, height: 40 }   // 大型车
            ];
            
            // 设置画布尺寸
            canvas.width = GAME_WIDTH;
            canvas.height = GAME_HEIGHT;
            
            // 游戏状态
            let gameState = 'ready'; // ready, playing, over
            let score = 0;
            let highScore = localStorage.getItem('roadCrossingHighScore') ? parseInt(localStorage.getItem('roadCrossingHighScore')) : 0;
            let level = 1;
            let animationId;
            let lastTime = 0;
            let soundEnabled = true;
            
            // 更新最高分显示
            highScoreElement.textContent = highScore;
            
            // 玩家对象
            const player = {
                x: GAME_WIDTH / 2 - PLAYER_SIZE / 2,
                y: GAME_HEIGHT - 80, // 底部人行道位置
                width: PLAYER_SIZE,
                height: PLAYER_SIZE,
                speed: 6.5, // 进一步提高玩家速度以应对更多车辆
                moving: {
                    up: false,
                    down: false,
                    left: false,
                    right: false
                },
                isInvulnerable: false,
                color: '#FFD700'
            };
            
            // 车辆数组
            let cars = [];
            let carSpawnTimer = 0;
            const MIN_CAR_SPAWN_TIME = 250; // 大幅缩短生成间隔，增加车辆数量
            
            // 道路和人行道尺寸计算
            const ROAD_TOP = 100;
            const ROAD_HEIGHT = GAME_HEIGHT - 200;
            const LANE_HEIGHT = ROAD_HEIGHT / LANES;
            const SIDEWALK_HEIGHT = 100;
            
            // 初始化游戏
            function initGame() {
                // 重置游戏状态
                gameState = 'playing';
                score = 0;
                level = 1;
                cars = [];
                carSpawnTimer = 0;
                
                // 重置玩家位置
                player.x = GAME_WIDTH / 2 - PLAYER_SIZE / 2;
                player.y = GAME_HEIGHT - 80;
                player.isInvulnerable = false;
                
                // 更新UI
                scoreElement.textContent = score;
                levelElement.textContent = level;
                startScreen.classList.add('hidden');
                gameOverScreen.classList.add('hidden');
                scoreDisplay.classList.remove('hidden');
                levelDisplay.classList.remove('hidden');
                
                // 播放开始音效
                playSound('start');
                
                // 开始游戏循环
                lastTime = 0;
                if (animationId) cancelAnimationFrame(animationId);
                gameLoop();
            }
            
            // 游戏主循环
            function gameLoop(timestamp = 0) {
                if (gameState !== 'playing') return;
                
                // 计算时间增量
                const deltaTime = timestamp - lastTime;
                lastTime = timestamp;
                
                // 清空画布
                ctx.clearRect(0, 0, GAME_WIDTH, GAME_HEIGHT);
                
                // 绘制游戏元素
                drawGrass();
                drawSidewalks();
                drawRoad();
                drawPlayer();
                
                // 更新和绘制车辆
                updateCars(deltaTime);
                drawCars();
                
                // 处理玩家移动
                handlePlayerMovement(deltaTime);
                
                // 检测碰撞
                checkCollisions();
                
                // 检测是否到达对面
                checkGoal();
                
                // 继续循环
                animationId = requestAnimationFrame(gameLoop);
            }
            
            // 绘制草地
            function drawGrass() {
                // 顶部草地
                ctx.fillStyle = getComputedStyle(document.documentElement).getPropertyValue('--color-road-grass');
                ctx.fillRect(0, 0, GAME_WIDTH, SIDEWALK_HEIGHT / 2);
                
                // 底部草地
                ctx.fillRect(0, GAME_HEIGHT - SIDEWALK_HEIGHT / 2, GAME_WIDTH, SIDEWALK_HEIGHT / 2);
            }
            
            // 绘制人行道
            function drawSidewalks() {
                const sidewalkColor = getComputedStyle(document.documentElement).getPropertyValue('--color-road-sidewalk');
                
                // 顶部人行道(目标)
                ctx.fillStyle = sidewalkColor;
                ctx.fillRect(0, SIDEWALK_HEIGHT / 2, GAME_WIDTH, SIDEWALK_HEIGHT / 2);
                
                // 顶部人行道标记
                ctx.fillStyle = 'rgba(255, 255, 255, 0.3)';
                ctx.beginPath();
                ctx.moveTo(GAME_WIDTH / 2 - 30, SIDEWALK_HEIGHT - 10);
                ctx.lineTo(GAME_WIDTH / 2 + 30, SIDEWALK_HEIGHT - 10);
                ctx.lineWidth = 5;
                ctx.strokeStyle = 'rgba(255, 255, 255, 0.5)';
                ctx.stroke();
                
                // 底部人行道(起点)
                ctx.fillStyle = sidewalkColor;
                ctx.fillRect(0, GAME_HEIGHT - SIDEWALK_HEIGHT, GAME_WIDTH, SIDEWALK_HEIGHT / 2);
            }
            
            // 绘制马路
            function drawRoad() {
                // 马路背景
                ctx.fillStyle = getComputedStyle(document.documentElement).getPropertyValue('--color-road-asphalt');
                ctx.fillRect(0, ROAD_TOP, GAME_WIDTH, ROAD_HEIGHT);
                
                // 车道线
                ctx.strokeStyle = getComputedStyle(document.documentElement).getPropertyValue('--color-road-line');
                ctx.lineWidth = 3;
                ctx.setLineDash([15, 15]);
                
                for (let i = 1; i < LANES; i++) {
                    const y = ROAD_TOP + i * LANE_HEIGHT;
                    ctx.beginPath();
                    ctx.moveTo(0, y);
                    ctx.lineTo(GAME_WIDTH, y);
                    ctx.stroke();
                }
                
                // 重置线样式
                ctx.setLineDash([]);
            }
            
            // 绘制玩家
            function drawPlayer() {
                ctx.save();
                
                // 玩家闪烁效果（无敌状态）
                if (player.isInvulnerable) {
                    const blinkRate = 1000; // 闪烁周期(毫秒)
                    const visible = Math.floor(Date.now() / (blinkRate / 2)) % 2 === 0;
                    if (!visible) {
                        ctx.restore();
                        return;
                    }
                }
                
                // 绘制玩家（使用简单的人形图标）
                ctx.fillStyle = player.color;
                
                // 头部
                ctx.beginPath();
                ctx.arc(
                    player.x + player.width / 2,
                    player.y + player.height / 3,
                    player.width / 6,
                    0,
                    Math.PI * 2
                );
                ctx.fill();
                
                // 身体
                ctx.fillRect(
                    player.x + player.width / 3,
                    player.y + player.height / 2,
                    player.width / 3,
                    player.height / 3
                );
                
                // 四肢
                // 左臂
                ctx.fillRect(
                    player.x,
                    player.y + player.height / 2,
                    player.width / 3,
                    player.height / 8
                );
                // 右臂
                ctx.fillRect(
                    player.x + player.width * 2 / 3,
                    player.y + player.height / 2,
                    player.width / 3,
                    player.height / 8
                );
                // 左腿
                ctx.fillRect(
                    player.x + player.width / 3,
                    player.y + player.height * 5 / 6,
                    player.width / 6,
                    player.height / 6
                );
                // 右腿
                ctx.fillRect(
                    player.x + player.width * 5 / 12,
                    player.y + player.height * 5 / 6,
                    player.width / 6,
                    player.height / 6
                );
                
                ctx.restore();
            }
            
            // 更新车辆 - 增加了车辆生成频率
            function updateCars(deltaTime) {
                // 更新现有车辆
                for (let i = cars.length - 1; i >= 0; i--) {
                    const car = cars[i];
                    
                    // 根据方向移动车辆
                    if (car.direction === 'left') {
                        car.x -= car.speed * (deltaTime / 16); // 基于60fps的速度调整
                        // 车辆移出左边界
                        if (car.x + car.width < 0) {
                            cars.splice(i, 1);
                        }
                    } else {
                        car.x += car.speed * (deltaTime / 16);
                        // 车辆移出右边界
                        if (car.x > GAME_WIDTH) {
                            cars.splice(i, 1);
                        }
                    }
                }
                
                // 生成新车辆 - 生成间隔更短，概率更高
                carSpawnTimer += deltaTime;
                // 随等级提高减小间隔，基础值更小
                const spawnInterval = Math.max(MIN_CAR_SPAWN_TIME, 1000 - (level - 1) * 150);
                
                // 提高生成概率，并且随等级提升进一步提高
                const spawnProbability = 0.95 + (level - 1) * 0.01;
                if (carSpawnTimer > spawnInterval && Math.random() < spawnProbability) {
                    spawnCar();
                    carSpawnTimer = 0;
                    
                    // 有一定概率同时生成多辆车（不同车道）
                    if (Math.random() < 0.3 + (level - 1) * 0.05) {
                        setTimeout(() => {
                            if (gameState === 'playing') spawnCar();
                        }, 100 + Math.random() * 200);
                    }
                }
            }
            
            // 生成车辆
            function spawnCar() {
                // 随机选择车道
                const lane = Math.floor(Math.random() * LANES);
                
                // 随机选择方向
                const direction = Math.random() > 0.5 ? 'left' : 'right';
                
                // 随机选择车辆大小
                const sizeIndex = Math.floor(Math.random() * CAR_SIZES.length);
                const size = CAR_SIZES[sizeIndex];
                
                // 随机选择车辆颜色
                const colors = [
                    getComputedStyle(document.documentElement).getPropertyValue('--color-car-red'),
                    getComputedStyle(document.documentElement).getPropertyValue('--color-car-blue'),
                    getComputedStyle(document.documentElement).getPropertyValue('--color-car-yellow'),
                    getComputedStyle(document.documentElement).getPropertyValue('--color-car-black')
                ];
                const color = colors[Math.floor(Math.random() * colors.length)];
                
                // 计算车辆位置
                let x;
                if (direction === 'left') {
                    x = GAME_WIDTH; // 从右侧进入
                } else {
                    x = -size.width; // 从左侧进入
                }
                
                // 计算车道Y位置
                const y = ROAD_TOP + lane * LANE_HEIGHT + (LANE_HEIGHT - size.height) / 2;
                
                // 根据级别和车辆大小计算速度
                const baseSpeed = 7.2 + (level - 1) * 0.45; // 保持较快速度
                const sizeFactor = 1.5 - (sizeIndex * 0.15); // 大型车速度惩罚减小
                const speed = baseSpeed * sizeFactor * (0.8 + Math.random() * 0.6); // 较大的随机速度范围
                
                // 创建车辆对象
                const car = {
                    x,
                    y,
                    width: size.width,
                    height: size.height,
                    speed,
                    direction,
                    color
                };
                
                // 添加到车辆数组
                cars.push(car);
            }
            
            // 绘制车辆
            function drawCars() {
                cars.forEach(car => {
                    ctx.save();
                    
                    // 绘制车身
                    ctx.fillStyle = car.color;
                    ctx.fillRect(car.x, car.y, car.width, car.height);
                    
                    // 绘制车窗
                    ctx.fillStyle = 'rgba(173, 216, 230, 0.8)';
                    if (car.direction === 'left') {
                        ctx.fillRect(car.x + car.width * 0.1, car.y + car.height * 0.1, car.width * 0.3, car.height * 0.8);
                    } else {
                        ctx.fillRect(car.x + car.width * 0.6, car.y + car.height * 0.1, car.width * 0.3, car.height * 0.8);
                    }
                    
                    // 绘制车轮
                    const wheelSize = { width: car.width * 0.15, height: car.height * 0.3 };
                    ctx.fillStyle = '#222222';
                    
                    // 左前轮
                    ctx.fillRect(
                        car.x - wheelSize.width / 2,
                        car.y + car.height * 0.2 - wheelSize.height / 2,
                        wheelSize.width,
                        wheelSize.height
                    );
                    
                    // 左后轮
                    ctx.fillRect(
                        car.x - wheelSize.width / 2,
                        car.y + car.height * 0.8 - wheelSize.height / 2,
                        wheelSize.width,
                        wheelSize.height
                    );
                    
                    // 右前轮
                    ctx.fillRect(
                        car.x + car.width - wheelSize.width / 2,
                        car.y + car.height * 0.2 - wheelSize.height / 2,
                        wheelSize.width,
                        wheelSize.height
                    );
                    
                    // 右后轮
                    ctx.fillRect(
                        car.x + car.width - wheelSize.width / 2,
                        car.y + car.height * 0.8 - wheelSize.height / 2,
                        wheelSize.width,
                        wheelSize.height
                    );
                    
                    ctx.restore();
                });
            }
            
            // 处理玩家移动
            function handlePlayerMovement(deltaTime) {
                const moveDistance = player.speed * (deltaTime / 20); // 基于60fps的移动距离
                
                // 上移
                if (player.moving.up && player.y > SIDEWALK_HEIGHT / 2) {
                    player.y -= moveDistance;
                }
                
                // 下移
                if (player.moving.down && player.y + player.height < GAME_HEIGHT - SIDEWALK_HEIGHT / 2) {
                    player.y += moveDistance;
                }
                
                // 左移
                if (player.moving.left && player.x > 0) {
                    player.x -= moveDistance;
                }
                
                // 右移
                if (player.moving.right && player.x + player.width < GAME_WIDTH) {
                    player.x += moveDistance;
                }
            }
            
            // 检查碰撞
            function checkCollisions() {
                if (player.isInvulnerable) return;
                
                for (const car of cars) {
                    // 简单的矩形碰撞检测
                    if (
                        player.x < car.x + car.width &&
                        player.x + player.width > car.x &&
                        player.y < car.y + car.height &&
                        player.y + player.height > car.y
                    ) {
                        // 发生碰撞
                        collisionDetected();
                        return;
                    }
                }
            }
            
            // 碰撞处理
            function collisionDetected() {
                // 播放碰撞音效
                playSound('hit');
                
                // 游戏结束
                gameState = 'over';
                cancelAnimationFrame(animationId);
                
                // 添加屏幕震动效果
                canvas.classList.add('shake');
                setTimeout(() => {
                    canvas.classList.remove('shake');
                }, 500);
                
                // 更新分数和游戏结束界面
                finalScoreElement.textContent = score;
                
                // 检查是否是新纪录
                if (score > highScore) {
                    highScore = score;
                    localStorage.setItem('roadCrossingHighScore', highScore);
                    highScoreElement.textContent = highScore;
                }
                
                // 显示游戏结束界面
                setTimeout(() => {
                    gameOverScreen.classList.remove('hidden');
                }, 500);
            }
            
            // 检查是否到达目标
            function checkGoal() {
                // 检查玩家是否到达顶部人行道
                if (player.y + player.height < SIDEWALK_HEIGHT) {
                    // 成功到达，加分
                    score += 10;
                    scoreElement.textContent = score;
                    playSound('score');
                    
                    // 玩家弹跳效果
                    canvas.classList.add('bounce-once');
                    setTimeout(() => {
                        canvas.classList.remove('bounce-once');
                    }, 500);
                    
                    // 重置玩家位置到底部
                    player.x = GAME_WIDTH / 2 - PLAYER_SIZE / 2;
                    player.y = GAME_HEIGHT - 80;
                    
                    // 短暂无敌状态，防止刚出现就被撞
                    player.isInvulnerable = true;
                    setTimeout(() => {
                        player.isInvulnerable = false;
                    }, 1000);
                    
                    // 检查是否升级
                    const newLevel = Math.floor(score / 50) + 1;
                    if (newLevel > level) {
                        level = newLevel;
                        levelElement.textContent = level;
                        playSound('levelUp');
                    }
                }
            }
            
            // 播放音效
            function playSound(type) {
                if (!soundEnabled) return;
                
                const sound = sounds[type];
                if (sound) {
                    // 重置并播放音效
                    sound.currentTime = 0;
                    sound.play().catch(e => console.log('音效播放失败:', e));
                }
            }
            
            // 键盘控制
            document.addEventListener('keydown', (e) => {
                if (gameState !== 'playing') return;
                
                switch(e.code) {
                    case 'ArrowUp':
                        player.moving.up = true;
                        break;
                    case 'ArrowDown':
                        player.moving.down = true;
                        break;
                    case 'ArrowLeft':
                        player.moving.left = true;
                        break;
                    case 'ArrowRight':
                        player.moving.right = true;
                        break;
                    case 'KeyM':
                        soundEnabled = !soundEnabled;
                        break;
                }
            });
            
            document.addEventListener('keyup', (e) => {
                switch(e.code) {
                    case 'ArrowUp':
                        player.moving.up = false;
                        break;
                    case 'ArrowDown':
                        player.moving.down = false;
                        break;
                    case 'ArrowLeft':
                        player.moving.left = false;
                        break;
                    case 'ArrowRight':
                        player.moving.right = false;
                        break;
                }
            });
            
            // 移动设备触摸控制
            btnUp.addEventListener('touchstart', (e) => {
                e.preventDefault();
                if (gameState === 'playing') player.moving.up = true;
            });
            btnUp.addEventListener('touchend', (e) => {
                e.preventDefault();
                player.moving.up = false;
            });
            
            btnDown.addEventListener('touchstart', (e) => {
                e.preventDefault();
                if (gameState === 'playing') player.moving.down = true;
            });
            btnDown.addEventListener('touchend', (e) => {
                e.preventDefault();
                player.moving.down = false;
            });
            
            btnLeft.addEventListener('touchstart', (e) => {
                e.preventDefault();
                if (gameState === 'playing') player.moving.left = true;
            });
            btnLeft.addEventListener('touchend', (e) => {
                e.preventDefault();
                player.moving.left = false;
            });
            
            btnRight.addEventListener('touchstart', (e) => {
                e.preventDefault();
                if (gameState === 'playing') player.moving.right = true;
            });
            btnRight.addEventListener('touchend', (e) => {
                e.preventDefault();
                player.moving.right = false;
            });
            
            // 鼠标点击控制（用于桌面设备的虚拟按钮）
            btnUp.addEventListener('mousedown', () => {
                if (gameState === 'playing') player.moving.up = true;
            });
            btnUp.addEventListener('mouseup', () => {
                player.moving.up = false;
            });
            btnUp.addEventListener('mouseleave', () => {
                player.moving.up = false;
            });
            
            btnDown.addEventListener('mousedown', () => {
                if (gameState === 'playing') player.moving.down = true;
            });
            btnDown.addEventListener('mouseup', () => {
                player.moving.down = false;
            });
            btnDown.addEventListener('mouseleave', () => {
                player.moving.down = false;
            });
            
            btnLeft.addEventListener('mousedown', () => {
                if (gameState === 'playing') player.moving.left = true;
            });
            btnLeft.addEventListener('mouseup', () => {
                player.moving.left = false;
            });
            btnLeft.addEventListener('mouseleave', () => {
                player.moving.left = false;
            });
            
            btnRight.addEventListener('mousedown', () => {
                if (gameState === 'playing') player.moving.right = true;
            });
            btnRight.addEventListener('mouseup', () => {
                player.moving.right = false;
            });
            btnRight.addEventListener('mouseleave', () => {
                player.moving.right = false;
            });
            
            // 开始和重新开始按钮
            startButton.addEventListener('click', initGame);
            restartButton.addEventListener('click', initGame);
            
            // 初始绘制
            drawGrass();
            drawSidewalks();
            drawRoad();
            drawPlayer();
        });
    </script>
</body>
</html>
