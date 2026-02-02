# Cukee World - playwith404 Landing Page

Neo-Brutalism 스타일의 AI 영화 큐레이션 서비스 **Cukee** 홍보 웹사이트입니다.

> "선택 장애를 해결하는 AI 기반 영화 추천 서비스"

## Tech Stack

| Category | Technology |
|----------|------------|
| **Backend** | Ruby on Rails 8.1 |
| **Ruby Version** | 3.4.8 |
| **Database** | PostgreSQL 16 |
| **Frontend** | Hotwire (Turbo + Stimulus) |
| **CSS** | Tailwind CSS 4 + Neo-Brutalism |
| **Web Server** | Puma + Thruster |
| **Asset Pipeline** | Propshaft |
| **Caching** | Solid Cache, Solid Queue, Solid Cable |
| **Containerization** | Docker + Docker Compose |
| **Deployment** | Kamal / GCP Compute Engine |
| **CI/CD** | GitHub Actions |

## Features

- Gumroad 스타일 Neo-Brutalism 디자인
- 마우스 트래킹 패럴랙스 캐릭터 애니메이션
- 11개 SVG 캐릭터 시스템
- 3단계 요금제 (Free / Pro / Custom) + 월간/연간 토글
- Contact 폼 + Gmail SMTP 이메일 발송
- 반응형 모바일 메뉴

## Screenshots

### Hero Section
![Hero](app/assets/images/screenshots/homepage1.png)

### About Section
![About](app/assets/images/screenshots/homepage2.png)

### Services Section
![Services](app/assets/images/screenshots/homepage3.png)

### Contact Page
![Contact](app/assets/images/screenshots/homepage4.png)

### Console Page
![Console](app/assets/images/screenshots/homepage5.png)

## Project Structure

```
cukee-world/
├── app/
│   ├── assets/
│   │   ├── images/characters/    # SVG 캐릭터 파일
│   │   ├── stylesheets/          # CSS 스타일시트
│   │   └── tailwind/             # Tailwind CSS 설정
│   ├── controllers/
│   │   ├── pages_controller.rb   # 정적 페이지 (home, about, services, pricing)
│   │   └── contacts_controller.rb # Contact 폼 처리
│   ├── javascript/controllers/   # Stimulus 컨트롤러
│   │   ├── parallax_controller.js
│   │   ├── pricing_toggle_controller.js
│   │   └── mobile_menu_controller.js
│   ├── mailers/
│   │   └── contact_mailer.rb     # 문의 알림 이메일
│   ├── models/
│   │   └── contact.rb            # 문의 모델
│   └── views/
│       ├── pages/                # 페이지 템플릿
│       ├── shared/               # 공통 컴포넌트 (navbar, footer, cta)
│       └── contact_mailer/       # 이메일 템플릿
├── config/
│   ├── routes.rb                 # 라우팅
│   ├── database.yml              # DB 설정
│   └── deploy.yml                # Kamal 배포 설정
├── docker/
│   ├── Dockerfile
│   ├── docker-compose.yml        # 개발 환경
│   └── docker-compose.ssl.yml    # 프로덕션 (SSL)
└── .github/workflows/
    ├── ci.yml                    # 보안 스캔 + 린트
    └── deploy.yml                # GCP 배포
```

## Routes

| Path | Description |
|------|-------------|
| `/` | 랜딩 페이지 (Hero) |
| `/about` | 회사 소개 |
| `/services` | 서비스 상세 |
| `/pricing` | 요금제 안내 |
| `/contact` | 문의 페이지 |
| `/contacts/new` | 문의 폼 |
| `/contacts/thank_you` | 문의 완료 |
| `/up` | 헬스 체크 |

## Local Development

### Requirements

- Ruby 3.4+
- PostgreSQL 14+
- Node.js (for Tailwind)

### Setup

```bash
# 의존성 설치
bundle install

# 데이터베이스 생성 및 마이그레이션
rails db:create db:migrate

# 개발 서버 시작 (Rails + Tailwind watcher)
bin/dev
```

http://localhost:3000 접속

### Environment Variables

`.env.example`을 참고하여 `.env` 파일을 생성하세요:

```bash
# Database
DATABASE_URL=postgres://user:password@localhost:5432/cukee_world_development

# Email (Gmail SMTP)
SMTP_ADDRESS=smtp.gmail.com
SMTP_PORT=587
SMTP_USERNAME=your-email@gmail.com
SMTP_PASSWORD=your-app-password
CONTACT_EMAIL=playwith404@gmail.com
```

## Docker Development

```bash
# 빌드
docker compose build

# 실행 (PostgreSQL 헬스체크 후 Rails 시작)
docker compose up

# 백그라운드 실행
docker compose up -d
```

## Database Schema

### contacts

| Column | Type | Description |
|--------|------|-------------|
| `name` | varchar | 이름 (2-100자) |
| `email` | varchar | 이메일 (RFC 형식) |
| `company` | varchar | 회사명 (선택) |
| `message` | text | 문의 내용 (10-2000자) |
| `inquiry_type` | varchar | 문의 유형 (general/sales/support/partnership) |
| `status` | varchar | 상태 (pending/in_progress/completed) |

## SVG Characters

캐릭터 파일 위치: `app/assets/images/characters/`

| Character | Color Code | Description |
|-----------|------------|-------------|
| ghost.svg | #C8D9F0 | 고스트 (라이트 블루) |
| lemon.svg | #F5F0B5 | 레몬 (페일 옐로우) |
| heart.svg | #FADADD | 하트 (라이트 핑크) |
| star.svg | #D8D0E0 | 별 |
| bean.svg | #B8D4C8 | 콩 (세이지) |
| dog.svg | - | 강아지 |
| cloud.svg | - | 구름 |
| glasses.svg | - | 안경 |
| jelly.svg | - | 젤리 |
| olive.svg | - | 올리브 |
| rice.svg | - | 밥 |

## GCP Deployment

### GitHub Secrets

| Secret | Description |
|--------|-------------|
| `GCP_PROJECT_ID` | GCP 프로젝트 ID |
| `GCP_SA_KEY` | Service Account JSON |
| `GCE_INSTANCE` | Compute Engine VM 이름 |
| `GCE_ZONE` | VM Zone (asia-northeast3-a) |
| `RAILS_MASTER_KEY` | Rails 암호화 키 |
| `DATABASE_URL` | PostgreSQL 연결 URL |
| `SMTP_ADDRESS` | SMTP 서버 (smtp.gmail.com) |
| `SMTP_PORT` | SMTP 포트 (587) |
| `SMTP_USERNAME` | Gmail 계정 |
| `SMTP_PASSWORD` | Gmail 앱 비밀번호 |

### Deploy

`main` 브랜치에 push하면 자동 배포됩니다.

```
GitHub Actions Workflow:
1. Docker 이미지 빌드
2. GCP Artifact Registry에 푸시
3. GCE 인스턴스에 SSH 접속
4. docker-compose로 서비스 배포
5. 데이터베이스 마이그레이션
6. 헬스체크 (/up)
```

## CI/CD Pipeline

### CI (Pull Request & Push to main)

- **Brakeman**: Rails 보안 스캔
- **Bundler-audit**: 의존성 취약점 검사
- **ImportMap audit**: JS 의존성 검사
- **RuboCop**: Ruby 코드 스타일 검사

### CD (Push to main)

- Docker 이미지 빌드 및 푸시
- GCP Compute Engine 배포
- 무중단 배포

## Design System

### Neo-Brutalism Style

- Bold borders (4px)
- Heavy shadows
- High contrast colors
- Geometric design language

### Tailwind Classes

```css
/* 버튼 */
.btn-brutal
.btn-brutal-outline

/* 헤딩 */
.heading-brutal-xl
.heading-brutal-lg

/* 배지 */
.badge-brutal

/* 애니메이션 */
.animate-float
.animate-float-delay-1
.animate-float-delay-2
```

## Links

| Link | URL |
|------|-----|
| **Production** | https://cukee.world |
| **Service** | https://cukee.world/auth/login |
| **Contact** | playwith404@gmail.com |

## License

(c) 2026 playwith404. All rights reserved.
