function [Elapsed_date] = CountElapsedDate(exp_day,reference_day)
%この関数の概要をここに記述
%入力として受け取ったdouble型の日付(例:20220801)が、reference_dayから何日経過した日付なのかを計算し、経過日数を出力する
%注意点:入力引数reference_dayはdatetime型じゃないとダメ(あらかじめtrans_calrender.mを用いて作成しておくこと)
    analyzed_date = trans_calrender(exp_day);
    Elapsed_date = between(reference_day,analyzed_date,'Days');
end

