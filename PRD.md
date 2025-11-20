# Project Instructions for Developer – Grant Writing SaaS MVP

You will build a lightweight but fully functional **grant-writing SaaS product**.
The AI engine is complete. Your task is to build the full MVP with authentication, billing, usage
limits, and export features.
**Budget** : Kes 65,000
**Timeline** : 2 to 3 weeks
Bonus available for early delivery or polished UI.

## 1. User Authentication

Build the full authentication system.
Requirements:

- Email login
- Google OAuth
- Secure authentication using your chosen stack
- Store user profile, subscription status, usage, and generation history

## 2. Subscription System Using Paystack

Integration must support **recurring subscriptions only** for paid plans.
Plans and limits:

- Free Trial: 1 generation per month, no exports
- Starter: 3 generations per month
- Growth: 8 generations per month
- Pro: Unlimited generations
Starter, Growth, Pro include unlimited exports.
Requirements:
- Recurring subscriptions setup
- Webhooks for renewal, cancellation, and failed payments
- No one-off payments
- Auto-restrict features when subscription is inactive
- Prevent usage if payment fails
- Store subscription_reference and customer_reference
- Sync plan and limits in real time


## 3. Generation Flow

Build a three-step structured input form.
Form will include:

- Basic project info
- Needs and objectives
- Activities and outcomes
I will provide the final field list.
On submission:
- Call OpenAI API
- Generate a full grant-style document
- Save the result to the user dashboard
- Deduct one generation from the user's limit

## 4. Document Access and Editing

Users must be able to edit generated content.
Free Trial users:

- No PDF export
- No DOCX export
- Copy/paste only
Paid users:
- Export to DOCX
- Export to PDF
Use a reliable export API.

## 5. User Dashboard

Include:

- Generated documents
- Remaining generations
- Active plan
- Next billing date


- Payment history
- Export buttons (disabled for Free Trial)

## 6. Admin Dashboard

Admin features:

- User list
- Subscription status
- Usage logs
- Payments and transactions
- High-level usage analytics

## 7. Deliverables

Final deliverables include:

- Fully deployed MVP
- Authentication system
- Recurring billing with Paystack
- AI generation workflow
- Usage tracking
- Export logic
- User dashboard
- Admin dashboard
- Production deployment
- Full handover of codebase and accounts

## 8. Tech Requirements

You choose the stack. It must support:

- OAuth + email login
- Paystack subscriptions
- API calls
- DOCX and PDF export
- Usage limits
- Clean responsive UI


## 9. Integrations Needed

You will integrate the following:

**- OpenAI API**
I will provide the API key.
**- Paystack**
I will provide API keys and test mode credentials.
**- PDF and DOCX Export Tool**
You must select an export solution and create the account.
Accepted tools:
- DocxTemplater
- PDFMonkey
- PDFBlade
- Any stable export API of your choice
**Action required:**
Create the account for the selected export tool
    ● configure it
    ● Share the login credentials with me
       for future management and billing control.

## 10. Completion Criteria

The project is complete when:

- Login and subscriptions work smoothly
- Recurring billing is stable and synced
- Free Trial restrictions enforced
- Paid export features are working
- AI content generation is reliable
- Dashboards accurate
- Admin tools functional
- MVP fully deployed and ready for real users


