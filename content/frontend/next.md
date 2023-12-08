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
```

---

A React Framework for building production-ready web applications. Everything is in-built - routing, optimized rendering, data fetching, bundling, compiling, and more

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

```ts
// invoke it anywhere in the component
import { notFound } from "next/navigation";

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

## References
- Codevolution Playlist - [YouTube](https://youtube.com/playlist?list=PLC3y8-rFHvwjOKd6gdf4QtV1uYNiQnruI&si=1R3UV3WIhVnJR0sO)
- Official Docs: https://nextjs.org/docs
- Official Tutorial: https://nextjs.org/learn
