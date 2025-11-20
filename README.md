# Grant Writing SaaS MVP

AI-powered grant writing platform built with Ruby on Rails 8, featuring authentication, subscription management via Paystack, OpenAI integration for grant generation, and document export capabilities.

## 🚀 Features

- **AI-Powered Grant Generation**: Create professional grant proposals using OpenAI GPT-4
- **Authentication**: Email/password and Google OAuth via Devise + OmniAuth
- **Subscription Plans**: Paystack recurring billing with 4 tiers (Free Trial, Starter, Growth, Pro)
- **Usage Limits**: Track and enforce generation limits per plan
- **Document Management**: Edit, view, and manage generated proposals
- **Export Functionality**: PDF and DOCX export (paid plans only)
- **User Dashboard**: Overview of usage, documents, and subscription
- **Responsive UI**: Modern, beautiful design with TailwindCSS

## 📋 Tech Stack

- **Backend**: Ruby on Rails 8.0.3
- **Database**: SQLite (development/test), PostgreSQL (production)
- **Frontend**: TailwindCSS, Stimulus JS, Hotwire (Turbo)
- **Authentication**: Devise + OmniAuth
- **Payment**: Paystack
- **AI**: OpenAI GPT-4
- **Export**: wicked_pdf, docx gem

## 🛠️ Setup Instructions

### Prerequisites

- Ruby 3.4+ 
- Rails 8.0.3
- Node.js (for asset compilation)
- PostgreSQL (for production)

### Installation

1. **Clone the repository** (if applicable)
   
2. **Install dependencies**:
   ```bash
   bundle install
   ```

3. **Configure environment variables**:
   Copy `.env.example` to `.env` and fill in your API keys:
   ```bash
   cp .env.example .env
   ```
   
   Required variables:
   - `OPENAI_API_KEY`: Your OpenAI API key
   - `PAYSTACK_PUBLIC_KEY`: Paystack public key
   - `PAYSTACK_SECRET_KEY`: Paystack secret key
   - `GOOGLE_CLIENT_ID`: Google OAuth client ID
   - `GOOGLE_CLIENT_SECRET`: Google OAuth client secret

4. **Setup database**:
   ```bash
   rails db:create db:migrate db:seed
   ```

5. **Start the server**:
   ```bash
   bin/dev
   ```
   
   Or separately:
   ```bash
   rails server
   ```

6. **Visit the application**:
   Open [http://localhost:3000](http://localhost:3000)

## 📦 Subscription Plans

The application includes 4 subscription tiers (defined in `db/seeds.rb`):

1. **Free Trial**: 1 generation/month, no exports
2. **Starter**: 3 generations/month, KES 999/month, exports enabled
3. **Growth**: 8 generations/month, KES 2,499/month, exports enabled
4. **Pro**: Unlimited generations, KES 4,999/month, exports enabled

## 🔐 Authentication

### Email/Password
- Users can register with email and password
- Password reset available via Devise

### Google OAuth
- One-click sign-in with Google
- Automatic account creation for new users
- Free Trial subscription created automatically

## 💳 Paystack Integration

### Subscription Creation
1. User selects a plan
2. Redirected to Paystack for payment
3. Payment processed securely
4. Webhook updates subscription status

### Webhooks
The following webhooks are handled at `/webhooks/paystack`:
- `charge.success`: Log successful payment
- `subscription.create`: Activate subscription
- `subscription.disable`: Cancel subscription
- `invoice.payment_failed`: Mark as past due

**Important**: Configure webhook URL in Paystack dashboard:
```
https://yourdomain.com/webhooks/paystack
```

## 🤖 OpenAI Integration

Grant generation uses GPT-4 via the `OpenaiService`:
- 3-step form collects project information
- AI generates comprehensive grant proposal
- Content saved to database
- Usage logged for limit tracking

## 📄 Document Exports

### PDF Export
- Uses `wicked_pdf` gem
- Formatted with professional styling
- Available for paid plans only

### DOCX Export
- Uses `docx` gem
- Editable Microsoft Word format
- Available for paid plans only

## 🗄️ Database Schema

### Main Models
- `User`: Authentication and profile
- `SubscriptionPlan`: Plan details and pricing
- `Subscription`: User subscription with Paystack references
- `Document`: Generated grant proposals
- `UsageLog`: Generation tracking
- `PaymentTransaction`: Payment history

## 🚀 Production Deployment

### Database Setup
The application uses PostgreSQL in production. Configure via environment variables:

```yaml
# config/database.yml
production:
  adapter: postgresql
  database: grant_sass_production
  # ... other config
```

### Podman Container (PostgreSQL)
For PostgreSQL via Podman:
```bash
podman run -d \
  --name grant-sass-postgres \
  -e POSTGRES_PASSWORD=yourpassword \
  -e POSTGRES_DB=grant_sass_production \
  -p 5432:5432 \
  postgres:16
```

### Environment Variables
Set these in your production environment:
- `DATABASE_URL` or individual PostgreSQL connection params
- All API keys from `.env.example`
- `SECRET_KEY_BASE` (run `rails secret`)

### Deployment Platforms
Recommended platforms:
- **Heroku**: Easy Rails deployment
- **Render**: Modern platform with database
- **Fly.io**: Global edge deployment
- **Custom VPS**: With Kamal (included in Rails 8)

## 📚 Key Files & Directories

```
app/
├── controllers/
│   ├── dashboard_controller.rb      # User dashboard
│   ├── documents_controller.rb      # Document CRUD
│   ├── grants_controller.rb         # 3-step generation
│   ├── subscriptions_controller.rb  # Plan management
│   └── webhooks/
│       └── paystack_controller.rb   # Webhook handler
├── models/
│   ├── user.rb                      # User + OAuth
│   ├── subscription.rb              # Subscription logic
│   ├── subscription_plan.rb         # Plan definitions
│   ├── document.rb                  # Generated docs
│   ├── usage_log.rb                 # Usage tracking
│   └── payment_transaction.rb       # Payment history
├── services/
│   ├── paystack_service.rb          # Paystack API
│   ├── openai_service.rb            # OpenAI integration
│   └── export_service.rb            # PDF/DOCX export
└── views/
    ├── home/                        # Landing page
    ├── dashboard/                   # User dashboard
    ├── grants/                      # 3-step form
    ├── documents/                   # Document views
    └── subscriptions/               # Plan selection
```

## 🐛 Troubleshooting

### Common Issues

1. **Database URL error**: Comment out `DATABASE_URL` in `.env` for development
2. **OpenAI timeout**: Check API key and quota
3. **Paystack webhook failures**: Verify signature and endpoint URL
4. **Export not working**: Check if user has paid plan

### Logs
Check Rails logs for errors:
```bash
tail -f log/development.log
```

## 📝 TODO / Future Enhancements

- [ ] Admin dashboard for user management
- [ ] Email notifications for payments and limits
- [ ] Advanced analytics
- [ ] Document templates
- [ ] Team collaboration features
- [ ] Export customization options

## 🤝 Support

For questions or issues:
- Review code comments
- Check Rails logs
- Test with Paystack test mode
- Verify environment variables

## 📄 License

Proprietary - All rights reserved

---

**Built with Rails 8 + TailwindCSS + Hotwire**
