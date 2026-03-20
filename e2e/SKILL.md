---
name: e2e
description: Create or update Playwright E2E tests following the project's Page Object Model structure. Use /e2e create for new modules or /e2e update for existing ones.
---

# E2E Testing Skill

Generate Playwright E2E tests using the Page Object Model pattern based on existing module structures.

## Commands

| Command | Description |
|---------|-------------|
| `/e2e create <module>` | Create new E2E tests for a module |
| `/e2e update <module>` | Update existing E2E tests for a module |

`<module>` can be:
- A module name: `banner`, `product`
- A folder: `src/pages/cms/banner/` or `#Folder`
- A file: `src/pages/cms/banner/BannerPage.tsx` or `#File`

**Tip**: Use Kiro's `#File` or `#Folder` context to quickly reference the module source.

## When to Use This Skill

- User says "/e2e create" or "create e2e for [module]"
- User says "/e2e update" or "update e2e for [module]"
- User asks to "add tests for [module]"
- User wants to "generate playwright tests"

## Workflow

### Step 1: Analyze Existing Structure

Before creating any files, read the existing e2e structure to understand patterns:

```bash
# Check existing modules for reference
ls -la e2e/pages/
```

**IMPORTANT**: Always reference existing page objects in `e2e/pages/` as the source of truth for:
- Class naming conventions
- Method patterns
- Locator strategies
- Form handling approaches

### Step 2: Identify Module Route

Ask the user or inspect the source code to determine:
- The module's base URL path (e.g., `/configs/product`)
- Available pages: List, Create, Edit, Detail
- Form fields and their types

### Step 3: Create Files

For `/e2e create <module-name>`:

1. **Create page folder**: `e2e/pages/<module-name>/`
2. **Create page objects** based on existing patterns:
   - `<Module>ListPage.ts`
   - `<Module>CreatePage.ts`
   - `<Module>EditPage.ts` (if applicable)
   - `<Module>DetailPage.ts` (if applicable)
   - `index.ts` (exports)
3. **Create spec file**: `e2e/<module-name>.spec.ts`
4. **Update exports**: Add to `e2e/pages/index.ts`

For `/e2e update <module-name>`:

1. Read existing page objects
2. Compare with current UI/form fields
3. Update methods and locators as needed

## File Structure

```
e2e/
├── pages/
│   ├── <module-name>/
│   │   ├── <Module>ListPage.ts
│   │   ├── <Module>CreatePage.ts
│   │   ├── <Module>EditPage.ts
│   │   ├── <Module>DetailPage.ts
│   │   └── index.ts
│   └── index.ts
└── <module-name>.spec.ts
```

## Reference Pattern

**ALWAYS read existing modules first** to match the project's conventions:

```typescript
// Read these files to understand patterns:
// e2e/pages/product/ProductListPage.ts
// e2e/pages/product/ProductCreatePage.ts
// e2e/pages/product/index.ts
// e2e/product.spec.ts
```

Follow the same:
- Constructor pattern with `Page` injection
- Method naming (goto, fillForm, submit, expect*, click*)
- Locator strategies (getByRole, getByLabel, locator)
- Static `generateData()` for test data
- Tab switching for multi-language forms

## Example Usage

**User**: `/e2e create banner`

**Agent Actions**:
1. Read `e2e/pages/product/` files for reference
2. Ask about the banner module's URL path and form fields
3. Create `e2e/pages/banner/` with page objects
4. Create `e2e/banner.spec.ts`
5. Update `e2e/pages/index.ts`

**User**: `/e2e update product`

**Agent Actions**:
1. Read current `e2e/pages/product/` files
2. Check if UI has changed (new fields, renamed elements)
3. Update page objects to match current UI
4. Update spec file if needed

## Tips

- Keep page objects focused on UI interactions
- Use descriptive method names
- Match existing locator strategies in the project
- Include both Thai and English tab handling if applicable
- Add `generateData()` static method for test data generation
