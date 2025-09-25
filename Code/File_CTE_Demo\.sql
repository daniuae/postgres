CREATE TABLE files (
    file_id SERIAL PRIMARY KEY,       -- Unique ID for each file/folder
    name TEXT NOT NULL,               -- File or folder name
    parent_id INT REFERENCES files(file_id) ON DELETE CASCADE  -- Self-referencing foreign key
);

-- Root folders
INSERT INTO files (name, parent_id) VALUES 
('root', NULL),
('home', NULL);

-- Subfolders under 'home'
INSERT INTO files (name, parent_id) VALUES 
('user1', 2),     -- under home
('user2', 2);

-- Files under 'user1'
INSERT INTO files (name, parent_id) VALUES 
('fileA.txt', 3),   -- under user1
('fileB.txt', 3);

-- Subfolder under 'user1'
INSERT INTO files (name, parent_id) VALUES 
('docs', 3);

-- File under docs
INSERT INTO files (name, parent_id) VALUES 
('resume.pdf', 6);  -- under docs



WITH RECURSIVE file_paths AS (
  SELECT file_id, name, parent_id, name as path
  FROM files
  WHERE parent_id IS NULL    -- Anchor: top-level folders/files

  UNION ALL

  SELECT f.file_id, f.name, f.parent_id, CONCAT(fp.path, '/', f.name)
  FROM files f
  JOIN file_paths fp ON f.parent_id = fp.file_id   -- Recursive: build full path
)
SELECT file_id, path
FROM file_paths
ORDER BY file_id;

