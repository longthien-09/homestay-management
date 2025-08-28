<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .footer-spacer { height:64px; }
    .site-footer { margin-top:0; padding:18px 20px; background:#f8f9fa; color:#6c757d; border-top:1px solid #eee; font-size:14px; position: fixed; left:0; right:0; bottom:0; width:100%; box-sizing:border-box; z-index: 9000; }
    .site-footer .row { display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:10px; }
    .site-footer a { color:#0d6efd; text-decoration:none; }
    .site-footer a:hover { text-decoration:underline; }
</style>
<div class="footer-spacer"></div>
<footer class="site-footer">
    <div class="row">
        <div>© <%= java.time.Year.now() %> Homestay Management</div>
        <div>
            <a href="#">Privacy</a> ·
            <a href="#">Terms</a> ·
            <a href="#">Contact</a>
        </div>
    </div>
</footer>
