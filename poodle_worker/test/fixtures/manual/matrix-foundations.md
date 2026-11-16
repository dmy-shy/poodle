# Matrix foundations: synthetic notebook test source

This document is test material. It contains no personal information.

## Vocabulary

A matrix is a rectangular array of numbers. Its shape is written rows by columns. A 3 by 2 matrix has three rows and two columns. A vector can be represented as a matrix with one column. Each entry has a row index and a column index; the entry in row 2, column 1 is distinct from the entry in row 1, column 2.

## Equality and addition

Two matrices are equal only when they have the same shape and corresponding entries are equal. Matrix addition also requires equal shapes. Add corresponding entries to obtain the result. For example, [[1, 2], [3, 4]] plus [[5, 6], [7, 8]] equals [[6, 8], [10, 12]]. The zero matrix acts as the additive identity for matrices of a fixed shape.

## Scalar multiplication

Multiplying a matrix by a scalar multiplies every entry. For example, 3 times [[1, -2], [0, 4]] is [[3, -6], [0, 12]]. Scalar multiplication distributes over matrix addition. Multiplication by zero produces the zero matrix, but multiplying a system equation by zero is not an invertible row operation.

## Matrix multiplication

The product AB is defined when the number of columns of A equals the number of rows of B. If A is m by n and B is n by p, then AB is m by p. The entry in row i and column j of AB is the dot product of row i of A with column j of B. Matrix multiplication is generally not commutative: AB and BA may differ or one may be undefined.

## Worked multiplication

Let A = [[1, 2], [3, 4]] and B = [[2, 0], [1, 5]]. The first row of AB is [1(2)+2(1), 1(0)+2(5)] = [4, 10]. The second row is [3(2)+4(1), 3(0)+4(5)] = [10, 20]. Therefore AB = [[4, 10], [10, 20]]. Check the shapes before computing any dot products.

## Identity matrix

The identity matrix I has ones on its main diagonal and zeros elsewhere. For any compatible matrix A, AI = A and IA = A. In two dimensions, I = [[1, 0], [0, 1]]. The identity is the multiplicative identity; it is different from the zero matrix, which is the additive identity.

## Transpose

The transpose exchanges rows and columns. If A is 2 by 3, its transpose is 3 by 2. The transpose of a column vector is a row vector. The transpose of a product reverses order: (AB)^T = B^T A^T. A symmetric square matrix equals its own transpose.

## Determinant and invertibility

For A = [[a, b], [c, d]], det(A) = ad - bc. If det(A) is nonzero, A has an inverse. If det(A) is zero, A is singular and has no inverse. For [[1, 2], [3, 4]], the determinant is 1(4) - 2(3) = -2, so the matrix is invertible.

## Two by two inverse

When ad - bc is nonzero, the inverse of [[a, b], [c, d]] equals 1/(ad - bc) times [[d, -b], [-c, a]]. Multiplying a matrix by its inverse gives the identity matrix. The inverse method for Ax = b is x = A^{-1}b, provided A is square and invertible.

## Linear combinations and span

A linear combination of vectors v and w has the form av + bw for scalars a and b. The span of a set of vectors contains every linear combination of those vectors. Two nonparallel vectors in the plane span the entire plane. If one vector is a scalar multiple of the other, their span is only a line through the origin.

## Linear independence

Vectors are linearly independent when the only way to combine them to get the zero vector is to use all zero coefficients. In the plane, two nonparallel nonzero vectors are independent. If one is a scalar multiple of the other, they are dependent. The pivot columns of a matrix identify a set of independent columns.

## Rank and null space

The rank is the number of pivot columns after row reduction. It counts independent columns and cannot exceed either dimension of a matrix. The null space of A is the set of vectors x satisfying Ax = 0. A free variable in a consistent homogeneous system produces nonzero vectors in the null space.

## Systems and augmented matrices

The system 2x + y = 7 and x - y = 2 can be written as [[2, 1], [1, -1]] [x, y]^T = [7, 2]^T. The augmented matrix is [[2, 1, 7], [1, -1, 2]]. Adding the equations gives 3x = 9, hence x = 3 and y = 1. Check both equations: 2(3)+1 = 7 and 3-1 = 2.

## Consistency

An augmented row [0, 0, 5] represents the false statement 0 = 5 and proves that a system is inconsistent. An augmented row [0, 0, 0] represents 0 = 0; it does not prove inconsistency. A consistent system with a free variable has infinitely many solutions, while one with a pivot in every variable column has a unique solution.

## Study checks

Before producing an answer, check dimensions, identify the operation, show each arithmetic step, and verify a proposed solution in the original equations. When a source does not supply a requested fact, say that the available material is insufficient rather than inventing it.
