+++
title = "Next"
date = 2023-12-08T17:00:00+05:30
weight = 2
pre = "🔼 "
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
layout.tsx
template.tsx


metadata object
generatedMetadata function object


<Link href="/products">Go to Products<Link/>


"use client";


useRouter
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

**Private Folders**: name a route folder as `_foobar` and it won't be accessible in the browser

**Route Group**: name a folder as `(foobar)` and it won't have its own URL segment anymore

## Layouts
Place common HTML tags in a `layout.tsx` file and it will be applied to a route and all its children.

The `layout.tsx` file in `app` folder (_mandatory_) allow common HTML tags such as `<header>` and `<footer>` placed in the file, to display on all it and its children route pages too.

**Nested Layout**: create `layout.tsx` file in a route's folder and it will be applied to it and all its children routes. Do note that any other layout of this route's parent will also be applied to its children.

**Route Group Layout**: place a `layout.tsx` file in a route group folder `(auth)` to scope layout to its child folders only

## Metadata
Place objects in either `layout.tsx` or `page.tsx` and Next generates HTML tags automatically. The latter takes precedence if there is ambiguity.

**Static Metadata Object**: create `metadata` object in the file
```js
export const metadata = {
	title: "Foobar::Home",
	description: "Homepage of Foobar"
};
```

They will be rendered as `<title>` and `<meta name="description" content="Homepage of Foobar">` in the browser.

**Dynamic Metadata**: create `generatedMetadata` function object in the file

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

### Navigating Programmatically
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
Any state variable disaplyed on the screen in the `layout.tsx` doesn't reset value when navigating between routes, it stays on the screen! 

Use `template.tsx` if we want to have new state variable initialized for every route we goto. Everything else is same as layout.


## References
- Codevolution Playlist - [YouTube](https://youtube.com/playlist?list=PLC3y8-rFHvwjOKd6gdf4QtV1uYNiQnruI&si=1R3UV3WIhVnJR0sO)
- Official Docs: https://nextjs.org/docs
- Official Tutorial: https://nextjs.org/learn
