<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>进阶版贪吃蛇</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        primary: '#4F46E5',
                        secondary: '#EC4899',
                        dark: '#1F2937',
                        light: '#F9FAFB'
                    },
                    fontFamily: {
                        game: ['Poppins', 'sans-serif'],
                    },
                }
            }
        }
    </script>
    <style type="text/tailwindcss">
        @layer utilities {
            .content-auto {
                content-visibility: auto;
            }
            .grid-bg {
                background-size: 20px 20px;
                background-image: 
                    linear-gradient(to right, rgba(255,255,255,0.05) 1px, transparent 1px),
                    linear-gradient(to bottom, rgba(255,255,255,0.05) 1px, transparent 1px);
            }
            .text-shadow {
                text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            }
            .rainbow-1 { background: linear-gradient(90deg, #FF5E5E, #FF7D5E); }
            .rainbow-2 { background: linear-gradient(90deg, #FF7D5E, #FFB347); }
            .rainbow-3 { background: linear-gradient(90deg, #FFB347, #FFF275); }
            .rainbow-4 { background: linear-gradient(90deg, #FFF275, #93FF96); }
            .rainbow-5 { background: linear-gradient(90deg, #93FF96, #42D7F5); }
            .rainbow-6 { background: linear-gradient(90deg, #42D7F5, #7D5FFF); }
            .rainbow-7 { background: linear-gradient(90deg, #7D5FFF, #C774E8); }
            .rainbow-8 { background: linear-gradient(90deg, #C774E8, #FF5E5E); }
        }
    </style>
</head>
<body class="bg-dark font-game text-light min-h-screen flex flex-col items-center justify-center p-4">
    <div class="max-w-3xl w-full">
        <header class="mb-4 flex justify-between items-center">
            <h1 class="text-[clamp(1.5rem,5vw,2.5rem)] font-bold text-transparent bg-clip-text bg-gradient-to-r from-primary to-secondary text-shadow">进阶版贪吃蛇</h1>
            <div id="score-display" class="bg-dark/70 backdrop-blur-sm px-4 py-2 rounded-lg border border-white/10 shadow-lg">
                <span class="text-sm font-medium text-white/70">分数:</span>
                <span id="score" class="text-xl font-bold ml-2">0</span>
            </div>
        </header>
        
        <div class="relative bg-dark/80 rounded-xl overflow-hidden shadow-2xl border border-white/10">
            <canvas id="gameCanvas" class="w-full grid-bg"></canvas>
            
            <div id="gameOver" class="absolute inset-0 bg-dark/80 backdrop-blur-sm flex flex-col items-center justify-center hidden">
                <h2 class="text-4xl font-bold mb-2 text-transparent bg-clip-text bg-gradient-to-r from-red-500 to-yellow-500">游戏结束!</h2>
                <p class="text-xl mb-6">最终分数: <span id="finalScore" class="font-bold">0</span></p>
                <button id="restartButton" class="px-8 py-3 bg-gradient-to-r from-primary to-secondary rounded-full text-white font-bold shadow-lg hover:shadow-primary/30 hover:scale-105 transition-all duration-300">
                    <i class="fa fa-refresh mr-2"></i>重新开始
                </button>
            </div>
        </div>
        
        <div class="mt-6 text-center text-white/60 text-sm">
            <p>使用方向键 <i class="fa fa-arrow-up"></i> <i class="fa fa-arrow-down"></i> <i class="fa fa-arrow-left"></i> <i class="fa fa-arrow-right"></i> 控制蛇的移动</p>
            <p class="mt-1">每吃一个食物，蛇的速度会增加，颜色也会变化</p>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const canvas = document.getElementById('gameCanvas');
            const ctx = canvas.getContext('2d');
            const scoreDisplay = document.getElementById('score');
            const gameOverScreen = document.getElementById('gameOver');
            const finalScoreDisplay = document.getElementById('finalScore');
            const restartButton = document.getElementById('restartButton');
            
            // 设置Canvas尺寸
            function resizeCanvas() {
                const container = canvas.parentElement;
                const size = Math.min(container.clientWidth, window.innerHeight * 0.7);
                canvas.width = size;
                canvas.height = size;
            }
            
            resizeCanvas();
            window.addEventListener('resize', resizeCanvas);
            
            // 游戏变量
            let snake = [];
            let food = {};
            let direction = 'right';
            let nextDirection = 'right';
            let score = 0;
            let gameSpeed = 150;
            let gameInterval;
            let isGameOver = false;
            let gridSize;
            let snakeSize;
            let foodSize;
            let rainbowColors = [
                'rainbow-1', 'rainbow-2', 'rainbow-3', 'rainbow-4',
                'rainbow-5', 'rainbow-6', 'rainbow-7', 'rainbow-8'
            ];
            let currentColorIndex = 0;
            
            // 初始化游戏
            function initGame() {
                // 计算网格和元素大小
                gridSize = Math.floor(canvas.width / 30);
                snakeSize = gridSize * 0.8;
                foodSize = gridSize * 0.9;
                
                // 重置游戏状态
                snake = [
                    {x: 5 * gridSize, y: 5 * gridSize},
                    {x: 4 * gridSize, y: 5 * gridSize},
                    {x: 3 * gridSize, y: 5 * gridSize}
                ];
                direction = 'right';
                nextDirection = 'right';
                score = 0;
                gameSpeed = 150;
                isGameOver = false;
                currentColorIndex = 0;
                
                // 更新UI
                scoreDisplay.textContent = score;
                gameOverScreen.classList.add('hidden');
                
                // 生成第一个食物
                generateFood();
                
                // 开始游戏循环
                if (gameInterval) clearInterval(gameInterval);
                gameInterval = setInterval(gameLoop, gameSpeed);
            }
            
            // 生成食物
            function generateFood() {
                const maxX = canvas.width / gridSize - 1;
                const maxY = canvas.height / gridSize - 1;
                
                // 确保食物不会出现在蛇身上
                let overlapping;
                do {
                    overlapping = false;
                    food = {
                        x: Math.floor(Math.random() * maxX) * gridSize,
                        y: Math.floor(Math.random() * maxY) * gridSize
                    };
                    
                    // 检查是否与蛇重叠
                    for (let segment of snake) {
                        if (segment.x === food.x && segment.y === food.y) {
                            overlapping = true;
                            break;
                        }
                    }
                } while (overlapping);
            }
            
            // 绘制蛇
            function drawSnake() {
                snake.forEach((segment, index) => {
                    // 计算渐变色
                    const colorClass = rainbowColors[currentColorIndex % rainbowColors.length];
                    const colors = getGradientColors(colorClass);
                    
                    // 创建渐变色
                    const gradient = ctx.createLinearGradient(
                        segment.x, segment.y, 
                        segment.x + snakeSize, segment.y + snakeSize
                    );
                    gradient.addColorStop(0, colors.start);
                    gradient.addColorStop(1, colors.end);
                    
                    // 绘制蛇身体
                    ctx.fillStyle = gradient;
                    ctx.beginPath();
                    ctx.roundRect(
                        segment.x + (gridSize - snakeSize) / 2,
                        segment.y + (gridSize - snakeSize) / 2,
                        snakeSize, snakeSize, snakeSize / 4
                    );
                    ctx.fill();
                    
                    // 绘制眼睛（只在头部）
                    if (index === 0) {
                        ctx.fillStyle = '#fff';
                        
                        // 根据方向调整眼睛位置
                        let leftEyeX, leftEyeY, rightEyeX, rightEyeY;
                        const eyeSize = snakeSize / 8;
                        
                        switch(direction) {
                            case 'right':
                                leftEyeX = segment.x + snakeSize * 0.7;
                                leftEyeY = segment.y + snakeSize * 0.3;
                                rightEyeX = segment.x + snakeSize * 0.7;
                                rightEyeY = segment.y + snakeSize * 0.7;
                                break;
                            case 'left':
                                leftEyeX = segment.x + snakeSize * 0.3;
                                leftEyeY = segment.y + snakeSize * 0.3;
                                rightEyeX = segment.x + snakeSize * 0.3;
                                rightEyeY = segment.y + snakeSize * 0.7;
                                break;
                            case 'up':
                                leftEyeX = segment.x + snakeSize * 0.3;
                                leftEyeY = segment.y + snakeSize * 0.3;
                                rightEyeX = segment.x + snakeSize * 0.7;
                                rightEyeY = segment.y + snakeSize * 0.3;
                                break;
                            case 'down':
                                leftEyeX = segment.x + snakeSize * 0.3;
                                leftEyeY = segment.y + snakeSize * 0.7;
                                rightEyeX = segment.x + snakeSize * 0.7;
                                rightEyeY = segment.y + snakeSize * 0.7;
                                break;
                        }
                        
                        ctx.beginPath();
                        ctx.arc(leftEyeX, leftEyeY, eyeSize, 0, Math.PI * 2);
                        ctx.arc(rightEyeX, rightEyeY, eyeSize, 0, Math.PI * 2);
                        ctx.fill();
                        
                        // 绘制瞳孔
                        ctx.fillStyle = '#000';
                        ctx.beginPath();
                        ctx.arc(leftEyeX, leftEyeY, eyeSize / 2, 0, Math.PI * 2);
                        ctx.arc(rightEyeX, rightEyeY, eyeSize / 2, 0, Math.PI * 2);
                        ctx.fill();
                    }
                });
            }
            
            // 从颜色类获取渐变颜色
            function getGradientColors(colorClass) {
                const gradients = {
                    'rainbow-1': { start: '#FF5E5E', end: '#FF7D5E' },
                    'rainbow-2': { start: '#FF7D5E', end: '#FFB347' },
                    'rainbow-3': { start: '#FFB347', end: '#FFF275' },
                    'rainbow-4': { start: '#FFF275', end: '#93FF96' },
                    'rainbow-5': { start: '#93FF96', end: '#42D7F5' },
                    'rainbow-6': { start: '#42D7F5', end: '#7D5FFF' },
                    'rainbow-7': { start: '#7D5FFF', end: '#C774E8' },
                    'rainbow-8': { start: '#C774E8', end: '#FF5E5E' }
                };
                
                return gradients[colorClass] || { start: '#4F46E5', end: '#EC4899' };
            }
            
            // 绘制食物（旋转的星星）
            function drawFood() {
                ctx.save();
                ctx.translate(food.x + gridSize / 2, food.y + gridSize / 2);
                ctx.rotate(Date.now() / 1000); // 每秒旋转
                
                // 绘制星星
                ctx.beginPath();
                ctx.moveTo(0, -foodSize / 2);
                for (let i = 1; i < 10; i++) {
                    const angle = (i * 2 * Math.PI / 10) - (Math.PI / 2);
                    const radius = i % 2 === 0 ? foodSize / 2 : foodSize / 5;
                    ctx.lineTo(Math.cos(angle) * radius, Math.sin(angle) * radius);
                }
                ctx.closePath();
                
                // 创建径向渐变
                const gradient = ctx.createRadialGradient(
                    0, 0, 0,
                    0, 0, foodSize / 2
                );
                gradient.addColorStop(0, '#FFD700');
                gradient.addColorStop(0.5, '#FFA500');
                gradient.addColorStop(1, '#FF4500');
                
                ctx.fillStyle = gradient;
                ctx.fill();
                
                // 添加边框
                ctx.strokeStyle = 'rgba(255, 255, 255, 0.7)';
                ctx.lineWidth = 2;
                ctx.stroke();
                
                ctx.restore();
            }
            
            // 检查碰撞
            function checkCollision() {
                const head = {...snake[0]};
                
                // 检查是否碰到边界
                if (
                    head.x < 0 || 
                    head.x >= canvas.width || 
                    head.y < 0 || 
                    head.y >= canvas.height
                ) {
                    return true;
                }
                
                // 检查是否碰到自己
                for (let i = 1; i < snake.length; i++) {
                    if (head.x === snake[i].x && head.y === snake[i].y) {
                        return true;
                    }
                }
                
                return false;
            }
            
            // 游戏主循环
            function gameLoop() {
                // 清空画布
                ctx.clearRect(0, 0, canvas.width, canvas.height);
                
                // 更新方向
                direction = nextDirection;
                
                // 移动蛇
                const head = {x: snake[0].x, y: snake[0].y};
                
                switch(direction) {
                    case 'up':
                        head.y -= gridSize;
                        break;
                    case 'down':
                        head.y += gridSize;
                        break;
                    case 'left':
                        head.x -= gridSize;
                        break;
                    case 'right':
                        head.x += gridSize;
                        break;
                }
                
                // 将新头部添加到蛇身
                snake.unshift(head);
                
                // 检查是否吃到食物
                if (head.x === food.x && head.y === food.y) {
                    // 增加分数
                    score += 10;
                    scoreDisplay.textContent = score;
                    
                    // 增加速度
                    gameSpeed = Math.max(50, gameSpeed - 5);
                    
                    // 改变颜色
                    currentColorIndex++;
                    
                    // 生成新食物
                    generateFood();
                    
                    // 重新设置游戏间隔
                    clearInterval(gameInterval);
                    gameInterval = setInterval(gameLoop, gameSpeed);
                } else {
                    // 如果没吃到食物，移除尾部
                    snake.pop();
                }
                
                // 检查碰撞
                if (checkCollision()) {
                    gameOver();
                    return;
                }
                
                // 绘制蛇和食物
                drawSnake();
                drawFood();
            }
            
            // 游戏结束
            function gameOver() {
                isGameOver = true;
                clearInterval(gameInterval);
                finalScoreDisplay.textContent = score;
                gameOverScreen.classList.remove('hidden');
            }
            
            // 键盘控制
            document.addEventListener('keydown', (e) => {
                if (isGameOver && e.key === ' ') {
                    initGame();
                    return;
                }
                
                // 防止游戏过程中滚动页面
                if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', ' '].includes(e.key)) {
                    e.preventDefault();
                }
                
                // 控制方向
                switch(e.key) {
                    case 'ArrowUp':
                        if (direction !== 'down') {
                            nextDirection = 'up';
                        }
                        break;
                    case 'ArrowDown':
                        if (direction !== 'up') {
                            nextDirection = 'down';
                        }
                        break;
                    case 'ArrowLeft':
                        if (direction !== 'right') {
                            nextDirection = 'left';
                        }
                        break;
                    case 'ArrowRight':
                        if (direction !== 'left') {
                            nextDirection = 'right';
                        }
                        break;
                }
            });
            
            // 触摸控制（移动端）
            let touchStartX = 0;
            let touchStartY = 0;
            
            canvas.addEventListener('touchstart', (e) => {
                touchStartX = e.touches[0].clientX;
                touchStartY = e.touches[0].clientY;
                e.preventDefault();
            }, { passive: false });
            
            canvas.addEventListener('touchmove', (e) => {
                e.preventDefault();
            }, { passive: false });
            
            canvas.addEventListener('touchend', (e) => {
                if (!touchStartX || !touchStartY) return;
                
                const touchEndX = e.changedTouches[0].clientX;
                const touchEndY = e.changedTouches[0].clientY;
                
                const diffX = touchEndX - touchStartX;
                const diffY = touchEndY - touchStartY;
                
                // 判断滑动方向
                if (Math.abs(diffX) > Math.abs(diffY)) {
                    // 水平滑动
                    if (diffX > 0 && direction !== 'left') {
                        nextDirection = 'right';
                    } else if (diffX < 0 && direction !== 'right') {
                        nextDirection = 'left';
                    }
                } else {
                    // 垂直滑动
                    if (diffY > 0 && direction !== 'up') {
                        nextDirection = 'down';
                    } else if (diffY < 0 && direction !== 'down') {
                        nextDirection = 'up';
                    }
                }
                
                touchStartX = 0;
                touchStartY = 0;
                e.preventDefault();
            }, { passive: false });
            
            // 重新开始按钮
            restartButton.addEventListener('click', initGame);
            
            // 初始化游戏
            initGame();
        });
    </script>
</body>
</html>
    
