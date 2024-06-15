--Ex1: hackerrank-more-than-75-marks.
select Name from STUDENTS
    where Marks > 75
    order by (right(Name,3)), ID;

--Ex2:leetcode-fix-names-in-a-table.
select user_id,
    concat(upper(left(name, 1)), lower(substring(name,2,length(name)))) as name
    from Users
order by user_id;
