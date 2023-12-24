+++
title = "Next"
date = 2023-12-08T17:00:00+05:30
weight = 2
pre = "<i class=\"devicon-nextjs-original colored\"></i> "
+++

## Cheatsheet
```txt
users    products

products/[productId]
products/[productId]/reviews/[reviewId]

docs/[...slug]
docs/[[...slug]]


_lib
(auth)


page.tsx and export default
not-found.tsx, notFound() method call
layout.tsx
template.tsx (init state variables on every render)
loading.tsx

error.tsx
Error Recovery with {reset} callback


metadata object
generatedMetadata function object


<Link href="/products">Go to Products<Link/>
useRouter().push("/goHere");

"use client";

@notifications slots as props in layout.tsx of parent
@notifications/archived (unmatched routes) and default.tsx

intercepting routes with (.)foobar
```

---

A React Framework for building production-ready web applications. Everything is built-in: routing, optimized rendering, data fetching, bundling, compiling, SEO, and more.

Components are by-default server components here, unless explicitly marked as client component using `use client` at the top.

**Folder Structure** - Every route goes inside the `src/app` folder, `layout.tsx` provides reusable UI structure to `page.tsx` (route specific page)

## Routing
Directory based routing (like Hugo's content folder) - route hierarchy is represented by folders

Rules:
1. A folder with a `page.tsx` is a route page
2. All route folders must be placed under `src/app` folder
3. Every folder becomes a URL path segment in the browser (even if its not a route)


**Route**: the `page.tsx` file must have atleast one React component (_function_) that **must** be an `export default`
```ts
export default function Products() {		// component name doesn't matter
	return <h1>Sample Product</h1>;
}
```  

**Nested Routes**: `/users` and `/products` - create a folder for each route having their own `page.tsx`.

**Dynamic Routes** - `products/2` - create a folder called `[productId]` and in its `page.tsx` use `params` variable to access URL path variable:
```ts
export default function Products({ params }) {
	return <h1> This product is = { params.productId } </h1>;
}
```

**Nested Dynamic Routes**: `/products/5/reviews/8` - create separate folders for `products` and `reviews` and do dynamic routing inside each using `[productId]` and `[reviewId]` folders

**Catch-all Segments**: `/docs/feature1/concept1/example1` - create a folder `docs/[...slug]` (can be named anything) and we can access segments in code as:
```ts
params.slug.length 		// 3

params.slug[0] 			// feature1
params.slug[1] 			// concept1
params.slug[2] 			// example1
```

But `/docs` will fail now as it doesn't have its own `page.tsx`. We can use `[[...slug]]` as an **optional catch-all** which matches `/docs` too including everything above.

## Not Found Page
Either create a global `not-found.tsx` and place in `app` folder root.

```js
// invoke it anywhere in the component
import { notFound } from "next/navigation";

// in component function
if(params.reviewId > 999){
	notFound();
}
```

Or create a local one, placed in the route folder (`app/reviews`). Local one will be given precedence over the global one.

## Files & Folders
We can have multiple files in a route folder but there can be only one `page.tsx`

We can have multiple functions in the `page.tsx` but atleast one has to be `export default` (only this will rendered)

**Private Folders**: name a route folder as `_foobar` and it and all its subfolders are excluded from routing

**Route Group**: name a folder as `(foobar)` and it won't need its own segment in the URL (_transparent_) when accessing subfolder routes (used to group related routes together for programmer ease)

## Layouts
Place common HTML tags in a `layout.tsx` file and it will be applied to a route and all its children. It is also applied to `not-found.tsx`, `error.tsx`, etc files.

The `layout.tsx` file in `app` folder (_mandatory_) allow common HTML tags such as `<header>` and `<footer>` placed in the file, to display on all it and its children route pages too.

**Nested Layout**: create `layout.tsx` file in a route's folder and it will be applied to it and all its children routes. Do note that any other layout of this route's parent will also be applied to its children.

**Route Group Layout**: as as good developer practice, place a `layout.tsx` file in a route group folder `(auth)` to scope layout to only certain route folders grouped logically

## Metadata
Place objects in either `layout.tsx` or `page.tsx` and Next generates HTML tags automatically. The latter takes precedence if there is ambiguity.

**Static Metadata Object**: create `metadata` object in the page file
```js
export const metadata = {
	title: "Foobar::Home",
	description: "Homepage of Foobar"
};
```

They will be rendered as `<title>` and `<meta name="description" content="Homepage of Foobar">` in the browser.

**Dynamic Metadata**: create `generatedMetadata` function object in the page file

```js
import { Metadata } from "next";

export const generatedMetadata = ({ params }): Metadata => {
	return {
		title: `Product ${params.productId}`
	};
};
```

### title
Set titles in the above two approaches, either as `string` type (shown above) or `Metadata` type (shown below).

```js
import { Metadata } from "next";

export const metadata: Metadata = {
	title: {
		absolute: "Override both the below titles to display this one",
		default: "Fallback to this title if no title is defined in layout.tsx or page.tsx",
		template: "%s | Get the value before pipe from children's title field"
	}
};
```

## Link Component Navigation

```js
import Link from "next/link";

// in JSX

// static link
<Link href="/products">Go to Products<Link/>

// dynamic link
let productId = 100;
<Link href=`/products/${productId}`>Go to {productId}<Link/>

// replace history; on back button click we go back to Home and not the previous page
<Link href="/products" replace>Go to Products<Link/>
```

### Navigating with useRouter
Use `useRouter` hook in a client component.

```js
"use client";
import { useRouter } from "next/navigation";

// in component function
const router = useRouter();

const handleClick = () => {
	console.log("Redirecting to Home...");

	router.push("/");

	// other methods
	router.replace("/");		// reset browser stack history and goto Home
	router.back();				// goto previous page in browser stack
	router.forward();			// goto next page in browser stack
}
```

## Templates
Any state variable displayed on the screen in the `layout.tsx` doesn't reset value when navigating between routes, it stays on the screen! 

Use `template.tsx` if we want to have new state variable initialized for every route we goto. Everything else is same as layout.

## Loading Page
Use `loading.tsx` file placed in route folder to display temporary content till actual content loads.

## Error Handling
Use `error.tsx` file placed in route folder with Client Component. Can receive an optional `error` prop. 

```js
"use client";

export default function ErrorBoundary( { error } ){
	return <div> { error.message } </div>
}
```

Any errors in the child components too will display this page.

**Error in Layouts** - any error thrown in `layout.tsx` won't be handled by the same folder's `error.tsx`. Place error file in parent folder to catch errors in subfolder layouts.

### Error Recovery
Use the provided `reset` callback function variable to re-render route page, if there is no errors on re-render the new route page is displayed instead of error page.
```js
"use client";

export default function ErrorBoundary( { error, reset } ){
	return <button onClick = { reset }>Try again</button>
}
```

## Parallel Routes with Slots
```js
// in Dashboard component
<Foo \>
<Bar \>
<Foobar \>
```
Instead of composing components like above, we can use them as "slots" to divide page into sections - every slot is a mini-app with its own error handling, sub-navigation, and state management.

Create route folders named as `@foobar` called "slots" to make parallel routes. They are automatically passed to the parent route folder's `layout.tsx` as props (no need to import). The additional `children` prop is nothing but content from `dashboard/page.tsx`.

```js
/*

\dashboard
	@analytics
	@notifications
	@users

*/

// in dashboard/layout.tsx
export default function MyDashboardLayout( { children, analytics, notifications, users } ){		// notice 4 slots
	return <div> {children} </div>
}
```

They aren't directly accessible from the browser even if we use their name in URL segments.

### Sub-Routing and Unmatched Routes
We can create normal route folders `archived` in a slot route folder `@notifications` and then we can route from `localhost:8080/dashboard` to `localhost:8080/dashboard/archived` (notice no _notifications_ in URL).

**Unmatched Routes**: if this folder exists for under this slot folder only and not for other parallel slots:
- Navigating from UI - other slots retain their previously active state and display that
- Page Refresh - this will cause 404 error page to display unless we define `default.tsx` for every slot including the `children` slot

### Conditional Routes
```js
// in dashboard/layout.tsx
export default function MyDashboardLayout( { children, users, guests } ){
	const isLoggedIn = true;
	return isLoggedIn ?
		( <div> { children } </div> ) : 
		( guests );
}
```

## Intercepting Routes
Open another page when user wants to go to a page.

Create folders with `(.)foobar` and display its `page.tsx` when we go from current route to `foobar` route. Subsequently on a reload, display actual route page rather than the intercept page.

```txt
(.) to match segments on the same level
(..) to match segments one level above
(...) to match segments from the root app dir
```

To create Modals - use combination of both slot (`@modal`) and intercept single image item page (`photo-gallery/9`) from the main gallery page.

```txt
\photo-gallery
	\[id]
	\@modal
		\(..)photo-gallery/[id]
			page.tsx
		default.tsx
```

## References
- Codevolution Playlist - [YouTube](https://youtube.com/playlist?list=PLC3y8-rFHvwjOKd6gdf4QtV1uYNiQnruI&si=1R3UV3WIhVnJR0sO)
- Official Docs: https://nextjs.org/docs
- Official Tutorial: https://nextjs.org/learn
