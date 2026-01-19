# playwith404 - Cukee SaaS Landing Page

Neo-Brutalism 디자인의 playwith404 모회사 소개 웹사이트입니다.
AI 기반 영화 큐레이션 서비스 **Cukee**를 SaaS 형태로 제공합니다.

## Tech Stack

- **Framework**: Ruby on Rails 8
- **Database**: PostgreSQL
- **CSS**: Tailwind CSS 4 + Neo-Brutalism
- **JavaScript**: Hotwire (Turbo + Stimulus)
- **Deployment**: Docker + GCP Compute Engine

## Features

- Gumroad 스타일 네오-브루탈리즘 디자인
- 마우스 패럴랙스 캐릭터 애니메이션
- 11개 캐릭터 SVG 시스템
- 3단계 요금제 (Free / Pro / Custom)
- Contact 폼 + 이메일 발송

## Local Development

### Requirements

- Ruby 3.4+
- PostgreSQL 14+

### Setup

```bash
# Install dependencies
bundle install

# Create database
rails db:create db:migrate

# Start dev server
bin/dev
```

Visit http://localhost:3000

## Docker

```bash
# Build
docker compose build

# Run
docker compose up
```

## SVG 캐릭터 파일

캐릭터 SVG 파일은 다음 경로에 위치해야 합니다:

```
app/assets/images/characters/
├── ghost.svg    (고스트 - #C8D9F0)
├── lemon.svg    (레몬 - #F5F0B5)
├── heart.svg    (하트 - #FADADD)
├── star.svg     (별 - #D8D0E0)
├── bean.svg     (콩 - #B8D4C8)
└── ... (필요에 따라 추가)
```

## GCP Deployment

### GitHub Secrets

| Secret | Description |
|--------|-------------|
| `GCP_PROJECT_ID` | GCP Project ID |
| `GCP_SA_KEY` | Service Account JSON |
| `GCE_INSTANCE` | Compute Engine VM name |
| `GCE_ZONE` | VM Zone (e.g., asia-northeast3-a) |
| `RAILS_MASTER_KEY` | config/master.key value |
| `DATABASE_URL` | PostgreSQL connection URL |
| `GMAIL_USERNAME` | Gmail SMTP 사용자 |
| `GMAIL_PASSWORD` | Gmail 앱 비밀번호 |

Push to main branch to auto-deploy.

## Pages

| Path | Page |
|------|------|
| `/` | Landing (Hero, About, Services, Pricing, CTA) |
| `/pricing` | Pricing (상세 요금제 + FAQ) |
| `/contacts/new` | Contact Form |

## Links

- **Service URL**: https://cukee.world/auth/login
- **Domain**: cukee.world
- **Contact**: playwith404@gmail.com

## License

(c) 2025 playwith404. All rights reserved.
