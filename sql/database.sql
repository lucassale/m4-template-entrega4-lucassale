CREATE DATABASE livraria;

CREATE TABLE books (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "pages" INT NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    "authorId" INT,
    FOREIGN KEY (authorId) REFERENCES authors(id) ON DELETE SET NULL
);

CREATE TABLE "books_categories" (
    "bookId" INT NOT NULL,
    "categoryId" INT NOT NULL,
    PRIMARY KEY ("bookId", "categoryId"),
    FOREIGN KEY ("bookId") REFERENCES "books"("id") ON DELETE CASCADE,
    FOREIGN KEY ("categoryId") REFERENCES "categories"("id") ON DELETE CASCADE
);


CREATE TABLE "categories" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "createdAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE "authors" (
    "id" SERIAL PRIMARY KEY,
    "name" VARCHAR(255) NOT NULL,
    "bio" TEXT NOT NULL
);

CREATE TABLE "contact_infos" (
    "id" SERIAL PRIMARY KEY,
    "phone" VARCHAR(50) NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "authorId" INT NOT NULL,
    FOREIGN KEY ("authorId") REFERENCES "authors"("id") ON DELETE CASCADE
);

-- Inserindo dados na tabela authors
INSERT INTO authors (name, bio) 
VALUES 
    ('Eiichiro Oda', 'Eiichiro Oda em um mangaká conhecido pela criação do mangá One Piece.') 
RETURNING id, name, bio;

INSERT INTO authors (name, bio) 
VALUES 
    ('J. K. Rowling', 'J. K. Rowling é uma escritora, roteirista e produtora cinematográfica britânica, notória por escrever a série de livros Harry Potter.') 
RETURNING id, name, bio;

INSERT INTO authors (name, bio) 
VALUES 
    ('Osvaldo Silva', 'Autor e compositor brasileiro.') 
RETURNING id, name, bio;

-- Inserindo dados na tabela books
INSERT INTO books (name, pages, createdAt, updatedAt, authorId) 
VALUES 
    ('Harry Potter', 325, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, (SELECT id FROM authors WHERE name = 'J. K. Rowling'))
RETURNING id, name, pages, createdAt, updatedAt, authorId;

INSERT INTO books (name, pages, createdAt, updatedAt, authorId) 
VALUES 
    ('Jogos Vorazes', 276, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL)
RETURNING id, name, pages, createdAt, updatedAt, authorId;

INSERT INTO books (name, pages, createdAt, updatedAt, authorId) 
VALUES 
    ('One Piece - Volume 1', 120, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL)
RETURNING id, name, pages, createdAt, updatedAt, authorId;

INSERT INTO books (name, pages, createdAt, updatedAt, authorId) 
VALUES 
    ('One Piece - Volume 2', 137, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, NULL)
RETURNING id, name, pages, createdAt, updatedAt, authorId;

-- Inserindo dados na tabela categories
INSERT INTO categories (name, createdAt, updatedAt) 
VALUES 
    ('Mangá', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
RETURNING id, name, createdAt, updatedAt;

INSERT INTO categories (name, createdAt, updatedAt) 
VALUES 
    ('Aventura', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
RETURNING id, name, createdAt, updatedAt;

INSERT INTO categories (name, createdAt, updatedAt) 
VALUES 
    ('Fantasia', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
RETURNING id, name, createdAt, updatedAt;

-- Inserindo dados na tabela books_categories
INSERT INTO books_categories (bookId, categoryId)
VALUES
    ((SELECT id FROM books WHERE name = 'Harry Potter'), (SELECT id FROM categories WHERE name = 'Aventura')),
    ((SELECT id FROM books WHERE name = 'Jogos Vorazes'), (SELECT id FROM categories WHERE name = 'Aventura')),
    ((SELECT id FROM books WHERE name = 'One Piece - Volume 1'), (SELECT id FROM categories WHERE name = 'Aventura')),
    ((SELECT id FROM books WHERE name = 'One Piece - Volume 2'), (SELECT id FROM categories WHERE name = 'Aventura')),
    ((SELECT id FROM books WHERE name = 'Harry Potter'), (SELECT id FROM categories WHERE name = 'Fantasia')),
    ((SELECT id FROM books WHERE name = 'One Piece - Volume 1'), (SELECT id FROM categories WHERE name = 'Fantasia')),
    ((SELECT id FROM books WHERE name = 'One Piece - Volume 2'), (SELECT id FROM categories WHERE name = 'Fantasia')),
    ((SELECT id FROM books WHERE name = 'One Piece - Volume 1'), (SELECT id FROM categories WHERE name = 'Mangá')),
    ((SELECT id FROM books WHERE name = 'One Piece - Volume 2'), (SELECT id FROM categories WHERE name = 'Mangá'));

-- Inserindo dados na tabela contact_infos
INSERT INTO contact_infos (phone, email, authorId) 
VALUES 
    ('(44) 99123-4567', 'osvaldo@osvaldocompany.com', (SELECT id FROM authors WHERE name = 'Osvaldo Silva'))
RETURNING id, phone, email, authorId;

-- Leitura de todos os livros
SELECT * FROM books;

-- Leitura de todos os livros da categoria "Fantasia"
SELECT b.*
FROM books b
JOIN books_categories bc ON b.id = bc.bookId
JOIN categories c ON bc.categoryId = c.id
WHERE c.name = 'Fantasia';

-- Leitura de todos os livros com suas respectivas categorias, renomeando colunas para evitar conflito
SELECT 
    b.id AS book_id,
    b.name AS book_name,
    b.pages AS book_pages,
    b.createdAt AS book_createdAt,
    b.updatedAt AS book_updatedAt,
    c.id AS category_id,
    c.name AS category_name
FROM books b
JOIN books_categories bc ON b.id = bc.bookId
JOIN categories c ON bc.categoryId = c.id;

-- Leitura do livro "Harry Potter" com as informações do autor, renomeando colunas para evitar conflito
SELECT 
    b.id AS book_id,
    b.name AS book_name,
    b.pages AS book_pages,
    b.createdAt AS book_createdAt,
    b.updatedAt AS book_updatedAt,
    a.id AS author_id,
    a.name AS author_name,
    a.bio AS author_bio
FROM books b
JOIN authors a ON b.authorId = a.id
WHERE b.name = 'Harry Potter';
