---
name: react
description: Building user interfaces with React — component design, hooks, state management, performance, and testing conventions for modern React applications. Use when creating or modifying React components or apps.
---

# React

## Component Design

- **Function components only** (no class components in new code).
- One component per file; file name matches component name in PascalCase (`UserCard.tsx` / `UserCard.jsx`).
- Prefer composition over configuration: build small, composable pieces rather than components with many boolean props.
- Keep components presentational where possible; extract logic into custom hooks.

## Hooks Rules

- Only call hooks at the top level — never in conditions, loops, or nested functions.
- `useState` for local UI state; lift state only when siblings need it.
- `useEffect` is for synchronization with external systems (subscriptions, DOM, network) — **not** for deriving state. Derive during render instead.
- Wrap expensive computations in `useMemo` and callbacks passed to memoized children in `useCallback` — but only when profiling shows a need.
- Extract reusable stateful logic into custom hooks (`useFetch`, `useLocalStorage`).

## State Management

- Default to local state; avoid global state until actually shared.
- Server state (fetching, caching) belongs in a dedicated library (e.g., React Query) or a well-isolated custom hook — not scattered `useEffect` calls.
- Keep state minimal and derive the rest: don't store what you can compute.

## Performance

- Don't optimize prematurely — measure first.
- Use keys correctly in lists (stable IDs, not array indices).
- Split code with `React.lazy` for large, rarely used components.

## Testing

- Test components the way users interact with them (React Testing Library): by role, label, and visible text.
- Query by accessibility role first (`getByRole`), then label, then text — avoid test IDs except as a last resort.
- Test behavior and outcomes, not internal state or implementation.

## Checklist Before Finishing

- [ ] Components are small and single-purpose
- [ ] No hooks in conditions/loops; effect dependencies complete
- [ ] State is minimal and colocated
- [ ] Lists have stable keys
- [ ] Tests cover user-visible behavior
