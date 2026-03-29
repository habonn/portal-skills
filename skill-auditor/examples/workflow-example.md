# Skill Auditor - Workflow Examples

Real-world scenarios showing how the Skill Auditor improves AI interactions.

## Scenario 1: Go Microservice with Clean Architecture

### Before Skill Auditor

**User:** "Create a new payment handler"

**AI (without context):**
```go
// Creates a single file with everything mixed together
package main

import (
    "database/sql"
    "net/http"
)

func PaymentHandler(w http.ResponseWriter, r *http.Request) {
    // Direct database access in handler
    db, _ := sql.Open("postgres", "...")
    // Business logic mixed with HTTP handling
    // No separation of concerns
}
```

**Problems:**
- Violates Clean Architecture principles
- Database access in presentation layer
- No dependency injection
- Doesn't follow project structure

### After Skill Auditor

**User:** "Create a new payment handler"

**AI (with skill context):**
```go
// domain/payment.go
package domain

type Payment struct {
    ID     string
    Amount float64
    Status string
}

type PaymentRepository interface {
    Create(payment *Payment) error
    FindByID(id string) (*Payment, error)
}

// application/payment_usecase.go
package application

type PaymentUseCase struct {
    repo domain.PaymentRepository
}

func NewPaymentUseCase(repo domain.PaymentRepository) *PaymentUseCase {
    return &PaymentUseCase{repo: repo}
}

func (uc *PaymentUseCase) ProcessPayment(payment *domain.Payment) error {
    // Business logic here
    return uc.repo.Create(payment)
}

// infrastructure/payment_repository.go
package infrastructure

type PostgresPaymentRepository struct {
    db *sqlx.DB
}

// presentation/payment_handler.go
package presentation

type PaymentHandler struct {
    useCase *application.PaymentUseCase
}
```

**Benefits:**
- Follows Clean Architecture layers
- Proper dependency injection
- Matches existing project structure
- Ready to integrate immediately

---

## Scenario 2: Payload CMS Project

### Before Skill Auditor

**User:** "Add a custom endpoint for user statistics"

**AI (without context):**
```typescript
// Creates Express route outside Payload
import express from 'express';

const app = express();

app.get('/api/user-stats', async (req, res) => {
  // Direct database query bypassing Payload
  const stats = await db.query('SELECT ...');
  res.json(stats);
});
```

**Problems:**
- Bypasses Payload's access control
- Creates route outside Payload system
- Direct database access
- No type safety

### After Skill Auditor

**User:** "Add a custom endpoint for user statistics"

**AI (with skill context):**
```typescript
// payload.config.ts
export default buildConfig({
  // ... existing config
  endpoints: [
    {
      path: '/user-stats',
      method: 'get',
      handler: async (req) => {
        // Uses Payload's access control
        const { user } = req;
        
        // Uses Payload's API
        const stats = await req.payload.find({
          collection: 'users',
          where: {
            // Proper query through Payload
          }
        });
        
        return Response.json({
          success: true,
          data: stats
        });
      }
    }
  ]
});
```

**Benefits:**
- Uses Payload endpoint system
- Respects access control
- Type-safe with Payload API
- Follows project conventions

---

## Scenario 3: Multi-Repo Context Switching

### Developer's Daily Workflow

**Morning: Working on Go service**

```
User: /skill-audit
AI: Detected Go 1.22 + Clean Architecture
     Skill file updated for payment-service

User: Add logging to payment processing
AI: [Creates structured logging in application layer, 
     following Clean Architecture rules]
```

**Afternoon: Switching to Node.js portal**

```
User: /skill-audit
AI: Detected Payload CMS 3.0 + Feature-based structure
     Skill file updated for company-portal

User: Add logging to user registration
AI: [Creates Payload hook for logging,
     following Payload conventions]
```

**Result:** AI automatically adapts to each project's patterns without manual prompting.

---

## Scenario 4: Team Collaboration

### Without Skill Auditor

**Developer A:**
```
User: Create user service
AI: [Creates MVC-style code]
```

**Developer B (same project):**
```
User: Create payment service
AI: [Creates different pattern, inconsistent with Developer A]
```

**Problem:** Inconsistent codebase, harder to maintain

### With Skill Auditor

**Developer A:**
```
User: /skill-audit
AI: Detected Clean Architecture
User: Create user service
AI: [Creates Clean Architecture layers]
```

**Developer B (pulls latest code with skill file):**
```
User: Create payment service
AI: [Automatically uses Clean Architecture, consistent with Developer A]
```

**Result:** Consistent codebase, easier collaboration

---

## Scenario 5: Preventing Common Mistakes

### Example: Database Access in Wrong Layer

**Without Skill Auditor:**
```go
// usecase/payment.go
func (uc *PaymentUseCase) Process(id string) error {
    // AI might suggest direct DB access
    db, _ := sql.Open("postgres", "...")
    // This violates Clean Architecture
}
```

**With Skill Auditor:**

The skill file contains:
```
❌ Don't: Put database queries in use cases
✅ Do: Use dependency injection for external services
```

**AI response:**
```go
// usecase/payment.go
func (uc *PaymentUseCase) Process(id string) error {
    // AI correctly uses injected repository
    payment, err := uc.repo.FindByID(id)
    if err != nil {
        return err
    }
    // Business logic here
    return uc.repo.Update(payment)
}
```

---

## Scenario 6: Framework Version Awareness

### Problem: Using Deprecated APIs

**Without Skill Auditor:**
```typescript
// AI suggests old Next.js 13 pattern
import { useRouter } from 'next/router';

export default function Page() {
  const router = useRouter();
  // This is deprecated in Next.js 15
}
```

**With Skill Auditor:**

Skill file shows: `Next.js 15.0.3`

**AI response:**
```typescript
// AI uses Next.js 15 App Router pattern
'use client';
import { useRouter } from 'next/navigation';

export default function Page() {
  const router = useRouter();
  // Correct for Next.js 15
}
```

---

## Scenario 7: Infrastructure-Aware Code

### Example: AWS Lambda vs Docker

**Lambda Project (detected by skill auditor):**
```typescript
// AI knows this runs on Lambda
export const handler = async (event: APIGatewayEvent) => {
  // Stateless, cold-start aware
  // No global state
  // Environment variables from Lambda
};
```

**Docker Project (detected by skill auditor):**
```typescript
// AI knows this runs in Docker
class PaymentService {
  private cache: Map<string, any>;
  
  constructor() {
    // Can maintain state
    // Long-running process
    this.cache = new Map();
  }
}
```

**Result:** Code is optimized for the actual deployment target.

---

## Measuring Success

### Metrics to Track

**Before Skill Auditor:**
- Time spent explaining project structure: ~15 min per session
- AI suggestions requiring refactoring: ~40%
- Context switching overhead: High

**After Skill Auditor:**
- Time spent explaining project structure: ~0 min (automatic)
- AI suggestions requiring refactoring: ~5%
- Context switching overhead: Minimal

### Qualitative Benefits

- Fewer "that's not how we do it here" moments
- More time coding, less time correcting AI
- Consistent patterns across team members
- Faster onboarding for new developers

---

## Next Steps

1. Run `/skill-audit` in your current project
2. Review the generated skill file
3. Add custom rules in `.skill-auditor.config.json` if needed
4. Enable hooks for automatic updates
5. Commit the skill file to share with your team

Happy coding! 🚀
