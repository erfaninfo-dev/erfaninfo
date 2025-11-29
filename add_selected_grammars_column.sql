-- اضافه کردن ستون selected_grammars به جدول results
ALTER TABLE results ADD COLUMN selected_grammars TEXT DEFAULT NULL;

-- بررسی اینکه ستون اضافه شده است
DESCRIBE results;

-- اضافه کردن ایندکس برای بهبود عملکرد جستجو (بعد از اضافه شدن ستون)
CREATE INDEX idx_selected_grammars ON results(selected_grammars(100)); 