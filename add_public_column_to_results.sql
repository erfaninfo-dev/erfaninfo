-- اضافه کردن ستون public به جدول results
ALTER TABLE results ADD COLUMN public BOOLEAN DEFAULT TRUE;
 
-- به‌روزرسانی نتایج موجود به public = TRUE
UPDATE results SET public = TRUE WHERE public IS NULL; 