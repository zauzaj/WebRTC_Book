# Using Claude Code with AutoAP Implementation

## 🤖 What is Claude Code?

Claude Code is a command-line tool that lets you delegate coding tasks to Claude directly from your terminal. It's perfect for implementing the AutoAP project because you can:

- Ask Claude to implement entire PRs
- Generate boilerplate code
- Debug issues
- Write tests
- Review code

## 🔗 How These Documents Work Together

```
┌─────────────────────────────────────────────────────────┐
│                    YOUR WORKFLOW                        │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. Read the PR docs (WEEK_1_IMPLEMENTATION.md)        │
│     ↓                                                   │
│  2. Use Claude Code to implement the PR                │
│     ↓                                                   │
│  3. Test against acceptance criteria                   │
│     ↓                                                   │
│  4. Commit and move to next PR                         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

## 📝 Step-by-Step: PR-01 Example

### Traditional Way (Manual):

```bash
# You would manually:
rails new autoop --database=postgresql --css=tailwind
cd autoop
# Edit Gemfile
bundle add devise
bundle add omniauth-quickbooks
# ... repeat for all gems
# Create config files
# Set up environment variables
# etc.
```

### With Claude Code:

```bash
# 1. Start in your projects directory
cd ~/projects

# 2. Use Claude Code to implement PR-01
claude-code "Implement PR-01 from AutoAP project.
Create a new Rails 7.1 app called 'autoop' with:
- PostgreSQL database
- Tailwind CSS
- All gems from the Gemfile list in WEEK_1_IMPLEMENTATION.md PR-01
- .env.example with all required environment variables
- Proper gitignore for Rails
- Initial README

Follow the exact specifications in PR-01."

# Claude Code will:
# - Create the Rails app
# - Add all gems
# - Set up configs
# - Create necessary files
# - Initialize git
```

## 🎯 Practical Examples

### Example 1: Implementing PR-02 (Database Schema)

```bash
cd autoop

claude-code "Implement PR-02 Database Schema from AutoAP.
Following WEEK_1_IMPLEMENTATION.md:

1. Install Devise and generate User model with company_name field
2. Generate QuickBooksConnection model with all fields
3. Generate Vendor model
4. Generate GlCode model
5. Generate Invoice model
6. Generate InvoiceLineItem model
7. Create pgvector migration for invoice_embeddings
8. Add all model associations as specified
9. Add model validations
10. Run all migrations

Show me what you created."
```

Claude Code will:

- ✅ Run all `rails generate` commands
- ✅ Create migration files
- ✅ Add associations to models
- ✅ Add validations
- ✅ Run `rails db:migrate`
- ✅ Show you a summary

### Example 2: Implementing PR-04 (QuickBooks OAuth)

```bash
claude-code "Implement PR-04 QuickBooks OAuth from AutoAP.

Create:
1. QuickBooksAuthController with connect, callback, disconnect actions
2. Update routes for QB auth endpoints
3. Implement OAuth2 flow as shown in WEEK_1_IMPLEMENTATION.md
4. Add token refresh logic to QuickBooksConnection model
5. Update dashboard view to show QB connection status

Use the exact code from PR-04 in WEEK_1_IMPLEMENTATION.md.
Test that routes are set up correctly."
```

### Example 3: Debugging an Issue

```bash
claude-code "I'm getting this error when trying to connect QuickBooks:

OAuth2::Error: invalid_grant

My .env has:
QB_CLIENT_ID=xxx
QB_CLIENT_SECRET=xxx
QB_REDIRECT_URI=http://localhost:3000/auth/quickbooks/callback

Help me debug this. Check:
1. Is the redirect URI correct in routes?
2. Is the OAuth flow implemented correctly per PR-04?
3. What could cause invalid_grant error?"
```

### Example 4: Implementing a Complex Feature

```bash
claude-code "Implement the OCR extraction feature from PR-07.

Create:
1. app/jobs/invoice_processor_job.rb
2. app/services/invoice_extractor.rb
3. lib/pdf_converter.rb
4. Add mini_magick gem
5. Implement the exact GPT-4 Vision prompt from the docs
6. Add error handling
7. Add retry logic

Use the code from WEEK_1_IMPLEMENTATION.md PR-07 as reference.
Make sure to handle multi-page PDFs."
```

## 💡 Power Patterns with Claude Code

### Pattern 1: "Show Me First"

```bash
claude-code "Before implementing PR-08 Embeddings,
show me the file structure you'll create and explain
how the vector similarity search will work based on
the implementation docs."
```

### Pattern 2: "Test-Driven"

```bash
claude-code "Write RSpec tests for the Invoice model
based on PR-02 specifications. Test:
- Associations
- Validations
- Confidence score calculation
- Status transitions

Then implement the model to pass the tests."
```

### Pattern 3: "Step-by-Step"

```bash
# Break complex PRs into smaller tasks
claude-code "First, just create the InvoicesMailbox
for email intake from PR-06. Don't implement the full
processing yet."

# Then:
claude-code "Now add the PDF extraction logic to the
InvoicesMailbox using Active Storage."

# Then:
claude-code "Finally, add the job queuing and
confirmation emails."
```

### Pattern 4: "Review and Fix"

```bash
claude-code "Review the QuickbooksService I just created.
Compare it to the implementation in PR-05.
Are there any bugs or missing error handling?
Fix any issues you find."
```

## 📋 Weekly Workflow with Claude Code

### Week 1 Example:

**Monday:** PR-01 & PR-02

```bash
# Morning
claude-code "Set up AutoAP Rails project per PR-01"

# Afternoon
claude-code "Create all database models per PR-02"
claude-code "Run migrations and test in Rails console"
```

**Tuesday:** PR-03

```bash
claude-code "Implement Devise authentication per PR-03.
Include custom signup form with company_name field."

claude-code "Style the auth pages with Tailwind as shown in PR-03"
```

**Wednesday-Thursday:** PR-04

```bash
# Wednesday
claude-code "Set up QuickBooks OAuth flow per PR-04.
Just the connect and callback actions first."

# Thursday
claude-code "Add token refresh logic and disconnect feature"
claude-code "Update dashboard to show QB connection status"
```

**Friday:** PR-05

```bash
claude-code "Implement QuickBooks sync service per PR-05.
Start with vendor sync only."

claude-code "Add GL codes sync and fuzzy matching"
claude-code "Create background job for syncing"
```

## 🚀 Advanced Usage

### Contextual Implementation

```bash
# Claude Code can see your files, so it understands context
cd autoop

claude-code "I see I have a User model. Now implement
the relationship with QuickBooksConnection per PR-02.
Update the User model and create the QuickBooksConnection
model with proper foreign keys."
```

### Incremental Development

```bash
# Build features iteratively
claude-code "Add basic PDF upload to Invoice model"

# Later:
claude-code "Now integrate Cloudflare R2 for PDF storage
instead of local storage. Update the config per PR-06."
```

### Code Generation from Specs

```bash
claude-code "Generate the complete InvoiceExtractor
service class from PR-07. Include:
- OpenAI client setup
- GPT-4 Vision API call
- JSON parsing
- Vendor matching
- Error handling

Follow the exact structure in the implementation docs."
```

## 🎓 Best Practices

### ✅ DO:

1. **Reference the PR docs explicitly**

   ```bash
   claude-code "Implement PR-04 from WEEK_1_IMPLEMENTATION.md"
   ```

2. **Break large PRs into chunks**

   ```bash
   claude-code "First create the controller for PR-04"
   claude-code "Now add the routes"
   claude-code "Now create the view"
   ```

3. **Test after each step**

   ```bash
   claude-code "Create a test user and verify Devise works"
   ```

4. **Ask for explanations**

   ```bash
   claude-code "Explain how the vector similarity search
   in PR-08 works and why we use pgvector"
   ```

### ❌ DON'T:

1. **Don't skip the docs**
   - Always read the PR documentation first
   - Understand what you're building

2. **Don't ask Claude to build everything at once**

   ```bash
   # ❌ Too vague:
   claude-code "Build the entire AutoAP app"

   # ✅ Better:
   claude-code "Implement PR-01: Project Setup"
   ```

3. **Don't ignore acceptance criteria**
   - After Claude implements, verify the checklist
   - Test manually

## 🧪 Testing with Claude Code

```bash
# Generate tests
claude-code "Write RSpec tests for the GlCodeClassifier
service from PR-09. Test:
- Embedding generation
- Similarity search
- Confidence scoring
- Learning from corrections"

# Run tests
rails test

# Fix failing tests
claude-code "These 3 tests are failing: [paste errors]
Fix the GlCodeClassifier to make them pass."
```

## 🐛 Debugging Workflow

```bash
# 1. Describe the problem
claude-code "I'm getting 'undefined method vendor_name'
when processing invoices. This is in the InvoiceExtractor
service from PR-07. Here's the error: [paste error]"

# 2. Claude investigates
# Claude will look at your code and identify the issue

# 3. Ask for fix
claude-code "Fix this issue and update the InvoiceExtractor"

# 4. Verify
claude-code "Create a test invoice and process it to verify the fix"
```

## 📊 Progress Tracking

Create a simple script to track PR completion:

```bash
# track-progress.sh
#!/bin/bash

echo "AutoAP Implementation Progress"
echo "=============================="
echo ""
echo "Week 1:"
echo "- [x] PR-01: Project Setup"
echo "- [x] PR-02: Database Schema"
echo "- [ ] PR-03: Devise Auth"
echo "- [ ] PR-04: QuickBooks OAuth"
echo "- [ ] PR-05: QB Data Sync"
```

Update after each PR completion!

## 🎯 Complete PR Implementation Example

Here's how to implement an entire PR with Claude Code:

```bash
# 1. Read the PR
cat WEEK_1_IMPLEMENTATION.md | grep -A 100 "PR-03"

# 2. Implement with Claude
claude-code "Implement PR-03: Devise Authentication

Tasks:
1. Configure Devise settings
2. Generate Devise views
3. Customize signup form with company_name field
4. Create dashboard controller
5. Add authentication filters
6. Style auth pages with Tailwind
7. Add flash messages

Use the exact code from PR-03 in WEEK_1_IMPLEMENTATION.md.
Create all necessary files."

# 3. Test acceptance criteria
# Manual testing in browser

# 4. Commit
git add .
git commit -m "feat: implement Devise authentication (PR-03)

- Configure Devise with proper settings
- Add company_name to signup
- Create styled auth pages
- Set up dashboard with auth protection
- Add flash message styling

Acceptance criteria:
✅ Users can sign up
✅ Users can log in/out
✅ Dashboard requires auth
✅ Flash messages display
✅ Auth pages styled with Tailwind"

# 5. Move to next PR
```

## 🔄 Iterative Development Cycle

```
┌──────────────────────────────────────────────┐
│                                              │
│  1. Read PR docs (understand requirements)  │
│              ↓                               │
│  2. Claude Code: "Implement PR-XX"          │
│              ↓                               │
│  3. Manual testing (check ✅ criteria)       │
│              ↓                               │
│  4. Claude Code: "Fix issue Y"              │
│              ↓                               │
│  5. Test again                              │
│              ↓                               │
│  6. Commit & push                           │
│              ↓                               │
│  7. Next PR                                 │
│              ↓                               │
│  (repeat)                                   │
│                                              │
└──────────────────────────────────────────────┘
```

## 💻 Sample Session: Building PR-01 to PR-05

```bash
# Week 1 - Day 1 Morning
cd ~/projects

claude-code "Create AutoAP Rails project per PR-01 from
WEEK_1_IMPLEMENTATION.md. Include all specified gems and
configuration."

cd autoop

# Test
rails server
# Visit http://localhost:3000 - should see Rails welcome

# Week 1 - Day 1 Afternoon
claude-code "Implement database schema from PR-02.
Create all models with associations and validations."

# Test
rails console
> User.new(email: 'test@example.com', password: 'password123', company_name: 'Test Co')
# Should create successfully

# Week 1 - Day 2
claude-code "Implement Devise authentication from PR-03.
Create signup/login pages with Tailwind styling."

# Test
rails server
# Visit http://localhost:3000/users/sign_up
# Should see styled signup form

# Week 1 - Day 3-4
claude-code "Implement QuickBooks OAuth from PR-04.
Set up full OAuth flow with sandbox credentials."

# Test in browser - OAuth flow should work

# Week 1 - Day 5
claude-code "Implement QuickBooks sync from PR-05.
Create service for syncing vendors and GL codes."

# Test
# Connect QB, click Sync Now, should see vendors/GL codes
```

## 📚 Reference Quick Commands

```bash
# Start new PR
claude-code "Show me what PR-XX involves from the docs"

# Implement feature
claude-code "Implement [feature] from PR-XX"

# Generate boilerplate
claude-code "Generate [model/controller/service] for [feature]"

# Debug issue
claude-code "Debug this error: [paste error]"

# Write tests
claude-code "Write tests for [feature]"

# Code review
claude-code "Review this [file/feature] for bugs"

# Refactor
claude-code "Refactor [file] to follow Rails best practices"

# Deploy help
claude-code "Help me deploy to Heroku per Week 6 deployment guide"
```

## 🎁 Bonus: Custom Aliases

Add to your `.bashrc` or `.zshrc`:

```bash
# AutoAP shortcuts
alias ap-implement='claude-code "Implement PR-$1 from AutoAP WEEK_1_IMPLEMENTATION.md"'
alias ap-test='claude-code "Test PR-$1 acceptance criteria"'
alias ap-debug='claude-code "Debug this AutoAP issue: $1"'
alias ap-review='claude-code "Review my AutoAP code for PR-$1"'

# Usage:
# ap-implement 01
# ap-test 02
# ap-debug "undefined method error"
```

## 🚀 Getting Started Right Now

```bash
# 1. Install Claude Code (if needed)
npm install -g @anthropic-ai/claude-code

# 2. Set up API key
export ANTHROPIC_API_KEY=your-key-here

# 3. Create project directory
mkdir ~/projects/autoop-build
cd ~/projects/autoop-build

# 4. Copy the implementation docs
# (You already have them!)

# 5. Start building!
claude-code "Let's build AutoAP! Start with PR-01 from
WEEK_1_IMPLEMENTATION.md. Create the Rails project with
all specified configuration."

# 6. Follow the PRs one by one
# PR-01 → PR-02 → PR-03 → ... → PR-16 → Launch! 🎉
```

## ✨ Summary

**Claude Code + Implementation Docs = Supercharged Development**

The implementation docs tell you **WHAT** to build.
Claude Code helps you **BUILD IT** faster.

1. 📖 Read the PR documentation
2. 🤖 Use Claude Code to implement
3. ✅ Test acceptance criteria
4. 🚀 Commit and move to next PR

In 6 weeks, you'll have a working AutoAP MVP!

**Ready to start? Run:**

```bash
claude-code "Implement PR-01 from AutoAP WEEK_1_IMPLEMENTATION.md"
```

Let's build! 💪
