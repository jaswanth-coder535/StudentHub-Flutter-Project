import os
import math
from PIL import Image, ImageDraw, ImageFont

# Canvas dimensions
W, H = 420, 880

# Load fonts
FONT_DIR = "C:/Windows/Fonts"
font_title = ImageFont.truetype(f"{FONT_DIR}/segoeuib.ttf", 22)
font_subtitle = ImageFont.truetype(f"{FONT_DIR}/segoeuib.ttf", 16)
font_body = ImageFont.truetype(f"{FONT_DIR}/segoeui.ttf", 13)
font_body_bold = ImageFont.truetype(f"{FONT_DIR}/segoeuib.ttf", 13)
font_small = ImageFont.truetype(f"{FONT_DIR}/segoeui.ttf", 11)
font_small_bold = ImageFont.truetype(f"{FONT_DIR}/segoeuib.ttf", 11)
font_tiny = ImageFont.truetype(f"{FONT_DIR}/segoeui.ttf", 9)
font_large = ImageFont.truetype(f"{FONT_DIR}/segoeuib.ttf", 26)

# Colors
BG_COLOR = (248, 250, 252) # #F8FAFC
CARD_BG = (255, 255, 255)
BORDER_COLOR = (226, 232, 240)
PRIMARY_BLUE = (30, 136, 229) # #1E88E5
PRIMARY_DARK = (13, 71, 161) # #0D47A1
PRIMARY_LIGHT = (227, 242, 253) # #E3F2FD
ACCENT_BLUE = (2, 132, 199)
TEXT_DARK = (30, 41, 59)
TEXT_MED = (71, 85, 105)
TEXT_LIGHT = (148, 163, 184)
SUCCESS_BG = (209, 250, 229)
SUCCESS_TEXT = (5, 150, 105)
DANGER_BG = (254, 226, 226)
DANGER_TEXT = (220, 38, 38)
WARN_BG = (254, 243, 199)
WARN_TEXT = (217, 119, 6)

def create_base():
    img = Image.new("RGB", (W, H), color=BG_COLOR)
    draw = ImageDraw.Draw(img)
    
    # Status bar
    draw.rectangle([0, 0, W, 40], fill=(255, 255, 255))
    draw.text((24, 12), "09:41", fill=TEXT_DARK, font=font_small_bold)
    # Signal, wifi, battery indicators (simple shapes)
    draw.ellipse([W - 75, 16, W - 67, 24], fill=TEXT_DARK)
    draw.rectangle([W - 60, 15, W - 48, 25], outline=TEXT_DARK, width=1)
    draw.rectangle([W - 58, 17, W - 51, 23], fill=TEXT_DARK)
    draw.rectangle([W - 35, 14, W - 18, 26], outline=TEXT_DARK, width=1)
    draw.rectangle([W - 33, 16, W - 22, 24], fill=TEXT_DARK)
    return img, draw

def draw_bottom_nav(draw, active_index=0):
    nav_y = H - 65
    draw.rectangle([0, nav_y, W, H], fill=(255, 255, 255), outline=BORDER_COLOR)
    
    items = ["Home", "Attendance", "Timetable", "Assignments", "Profile"]
    item_w = W / 5
    for i, title in enumerate(items):
        cx = i * item_w + item_w / 2
        is_active = (i == active_index)
        color = PRIMARY_BLUE if is_active else TEXT_LIGHT
        
        # simple icon placeholder circle/box
        draw.rounded_rectangle([cx - 10, nav_y + 10, cx + 10, nav_y + 30], radius=4, fill=color)
        draw.text((cx, nav_y + 45), title, fill=color, font=font_tiny, anchor="mm")

def draw_card(draw, box, fill=CARD_BG, outline=BORDER_COLOR, radius=14):
    draw.rounded_rectangle(box, radius=radius, fill=fill, outline=outline)

# 1. HOME DASHBOARD
def render_home():
    img, draw = create_base()
    
    # App Bar
    draw.rectangle([0, 40, W, 95], fill=(255, 255, 255))
    draw.ellipse([20, 50, 56, 86], fill=PRIMARY_LIGHT)
    draw.ellipse([30, 57, 46, 73], fill=PRIMARY_BLUE)
    draw.text((66, 52), "Welcome back,", fill=TEXT_MED, font=font_small)
    draw.text((66, 68), "Alex Johnson 👋", fill=TEXT_DARK, font=font_subtitle)
    
    # Bell icon
    draw.rounded_rectangle([W - 48, 54, W - 18, 84], radius=8, outline=BORDER_COLOR)
    draw.ellipse([W - 24, 52, W - 16, 60], fill=DANGER_TEXT)
    
    # Blue Hero Student Card
    draw.rounded_rectangle([20, 110, W - 20, 245], radius=18, fill=PRIMARY_BLUE)
    draw.rounded_rectangle([36, 122, 110, 142], radius=10, fill=(255, 255, 255, 60))
    draw.text((45, 126), "Semester 5", fill=(255, 255, 255), font=font_small_bold)
    draw.text((W - 100, 126), "21CS1045", fill=(255, 255, 255), font=font_small_bold)
    draw.text((36, 150), "Computer Science & Engineering", fill=(227, 242, 253), font=font_small)
    draw.text((36, 168), "Alex Johnson", fill=(255, 255, 255), font=font_title)
    
    # Hero Sub Stats
    draw.rounded_rectangle([36, 198, W - 36, 234], radius=10, fill=(255, 255, 255, 40))
    draw.text((75, 204), "Attendance", fill=(227, 242, 253), font=font_tiny)
    draw.text((75, 218), "86.4%", fill=(255, 255, 255), font=font_small_bold)
    draw.text((195, 204), "CGPA", fill=(227, 242, 253), font=font_tiny)
    draw.text((195, 218), "8.82", fill=(255, 255, 255), font=font_small_bold)
    draw.text((305, 204), "Pending", fill=(227, 242, 253), font=font_tiny)
    draw.text((305, 218), "3 Tasks", fill=(255, 255, 255), font=font_small_bold)
    
    # Section: Quick Access
    draw.text((20, 260), "Quick Access", fill=TEXT_DARK, font=font_subtitle)
    
    grid = [
        ("Attendance", (224, 242, 254), PRIMARY_BLUE),
        ("Timetable", (239, 246, 255), (37, 99, 235)),
        ("Assignments", (254, 243, 199), (217, 119, 6)),
        ("Study Notes", (237, 233, 254), (124, 58, 237)),
        ("Results", (236, 253, 245), (5, 150, 105)),
        ("My Profile", (241, 245, 249), TEXT_MED),
    ]
    card_w = (W - 40 - 20) / 3
    card_h = 74
    for idx, (title, bg, ic) in enumerate(grid):
        r, c = idx // 3, idx % 3
        x = 20 + c * (card_w + 10)
        y = 288 + r * (card_h + 10)
        draw_card(draw, [x, y, x + card_w, y + card_h])
        draw.ellipse([x + card_w/2 - 14, y + 10, x + card_w/2 + 14, y + 38], fill=bg)
        draw.rectangle([x + card_w/2 - 6, y + 18, x + card_w/2 + 6, y + 30], fill=ic)
        draw.text((x + card_w/2, y + 54), title, fill=TEXT_DARK, font=font_tiny, anchor="mm")
        
    # Section: Today's Schedule
    draw.text((20, 465), "Today's Schedule (Monday)", fill=TEXT_DARK, font=font_subtitle)
    draw.text((W - 85, 468), "Full Timetable >", fill=PRIMARY_BLUE, font=font_small_bold)
    
    classes = [
        ("CS501", "Design & Analysis of Algorithms", "09:00 AM - 10:00 AM", "Room 302", "Lecture"),
        ("CS502", "Database Management Systems", "10:00 AM - 11:00 AM", "Room 302", "Lecture"),
        ("CS503L", "Computer Networks Lab", "11:15 AM - 01:15 PM", "Networking Lab", "Lab"),
    ]
    sy = 495
    for code, name, t, rm, typ in classes:
        draw_card(draw, [20, sy, W - 20, sy + 64])
        draw.rounded_rectangle([32, sy + 10, 72, sy + 54], radius=8, fill=PRIMARY_LIGHT)
        draw.text((52, sy + 32), typ[0], fill=PRIMARY_BLUE, font=font_subtitle, anchor="mm")
        draw.text((82, sy + 12), name, fill=TEXT_DARK, font=font_body_bold)
        draw.text((82, sy + 36), f"{t}  •  {rm}", fill=TEXT_MED, font=font_small)
        
        # Badge
        draw.rounded_rectangle([W - 75, sy + 14, W - 32, sy + 32], radius=6, fill=PRIMARY_LIGHT)
        draw.text((W - 53, sy + 23), typ, fill=PRIMARY_DARK, font=font_tiny, anchor="mm")
        sy += 72
        
    # Section: Campus Notices
    draw.text((20, 720), "Campus Highlights & Notices", fill=TEXT_DARK, font=font_subtitle)
    draw_card(draw, [20, 745, W - 20, 805], fill=(240, 253, 244), outline=(187, 247, 208))
    draw.text((36, 755), "Mid-Semester Examinations Timetable", fill=(22, 101, 52), font=font_body_bold)
    draw.text((36, 775), "Mid-term evaluation for Sem 5 begins Dec 01, 2026. Hall tickets ready.", fill=(21, 128, 61), font=font_small)
    
    draw_bottom_nav(draw, active_index=0)
    img.save("assets/screenshots/home_dashboard.png")
    print("Generated home_dashboard.png")

# 2. ATTENDANCE SCREEN
def render_attendance():
    img, draw = create_base()
    
    # App Bar
    draw.rectangle([0, 40, W, 95], fill=(255, 255, 255), outline=BORDER_COLOR)
    draw.text((W/2, 67), "Attendance Overview", fill=TEXT_DARK, font=font_subtitle, anchor="mm")
    
    # Overall summary card
    draw_card(draw, [20, 110, W - 20, 275])
    
    # Circular Gauge representation
    cx, cy, cr = 75, 170, 42
    draw.ellipse([cx - cr, cy - cr, cx + cr, cy + cr], outline=(226, 232, 240), width=10)
    draw.arc([cx - cr, cy - cr, cx + cr, cy + cr], start=-90, end=218, fill=PRIMARY_BLUE, width=10)
    draw.text((cx, cy - 6), "86.4%", fill=TEXT_DARK, font=font_subtitle, anchor="mm")
    draw.text((cx, cy + 12), "Overall", fill=TEXT_LIGHT, font=font_tiny, anchor="mm")
    
    draw.text((140, 138), "Current Status", fill=TEXT_MED, font=font_small)
    draw.rounded_rectangle([W - 110, 134, W - 35, 156], radius=10, fill=SUCCESS_BG)
    draw.text((W - 72, 145), "Safe (≥75%)", fill=SUCCESS_TEXT, font=font_tiny, anchor="mm")
    draw.text((140, 165), "Min 75% required for exams.", fill=TEXT_LIGHT, font=font_small)
    draw.text((140, 185), "✓ You are in good standing!", fill=PRIMARY_BLUE, font=font_small_bold)
    
    draw.line([35, 225, W - 35, 225], fill=(241, 245, 249), width=1)
    
    # 3-col stats
    col_w = (W - 40) / 3
    draw.text((20 + col_w * 0.5, 240), "186", fill=TEXT_DARK, font=font_subtitle, anchor="mm")
    draw.text((20 + col_w * 0.5, 258), "Total Classes", fill=TEXT_MED, font=font_tiny, anchor="mm")
    
    draw.text((20 + col_w * 1.5, 240), "161", fill=SUCCESS_TEXT, font=font_subtitle, anchor="mm")
    draw.text((20 + col_w * 1.5, 258), "Attended", fill=TEXT_MED, font=font_tiny, anchor="mm")
    
    draw.text((20 + col_w * 2.5, 240), "25", fill=DANGER_TEXT, font=font_subtitle, anchor="mm")
    draw.text((20 + col_w * 2.5, 258), "Absent", fill=TEXT_MED, font=font_tiny, anchor="mm")
    
    draw.text((20, 295), "Subject-wise Breakdown", fill=TEXT_DARK, font=font_subtitle)
    
    subjects = [
        ("CS501", "Design & Analysis of Algorithms", "Dr. Alan Turing", 36, 32, 88.9, True),
        ("CS502", "Database Management Systems", "Prof. Edgar Codd", 34, 31, 91.2, True),
        ("CS503", "Computer Networks", "Dr. Vint Cerf", 30, 26, 86.7, True),
        ("CS504", "Software Engineering", "Dr. Margaret Hamilton", 28, 25, 89.3, True),
        ("CS506", "Cloud Computing & DevOps", "Prof. Werner Vogels", 26, 21, 80.8, True),
    ]
    
    ay = 325
    for code, name, prof, tot, att, pct, safe in subjects:
        draw_card(draw, [20, ay, W - 20, ay + 96])
        draw.rounded_rectangle([32, ay + 10, 80, ay + 26], radius=4, fill=PRIMARY_LIGHT)
        draw.text((56, ay + 18), code, fill=PRIMARY_DARK, font=font_tiny, anchor="mm")
        draw.text((90, ay + 12), name, fill=TEXT_DARK, font=font_body_bold)
        draw.text((32, ay + 32), f"Instructor: {prof}", fill=TEXT_LIGHT, font=font_small)
        
        draw.text((W - 75, ay + 12), f"{pct}%", fill=PRIMARY_BLUE if safe else DANGER_TEXT, font=font_subtitle)
        
        # progress bar
        draw.rounded_rectangle([32, ay + 52, W - 32, ay + 58], radius=3, fill=(241, 245, 249))
        draw.rounded_rectangle([32, ay + 52, 32 + (W - 64) * (att/tot), ay + 58], radius=3, fill=PRIMARY_BLUE if safe else DANGER_TEXT)
        
        draw.text((32, ay + 72), f"Present: {att}  •  Absent: {tot - att}  •  Total: {tot}", fill=TEXT_MED, font=font_small)
        
        # quick buttons
        draw.rounded_rectangle([W - 95, ay + 66, W - 32, ay + 88], radius=6, fill=SUCCESS_BG)
        draw.text((W - 63, ay + 77), "+ Present", fill=SUCCESS_TEXT, font=font_tiny, anchor="mm")
        
        ay += 105
        
    draw_bottom_nav(draw, active_index=1)
    img.save("assets/screenshots/attendance_screen.png")
    print("Generated attendance_screen.png")

# 3. TIMETABLE SCREEN
def render_timetable():
    img, draw = create_base()
    
    # App Bar
    draw.rectangle([0, 40, W, 95], fill=(255, 255, 255), outline=BORDER_COLOR)
    draw.text((W/2, 67), "Weekly Timetable", fill=TEXT_DARK, font=font_subtitle, anchor="mm")
    
    # Day Chips
    draw.rectangle([0, 95, W, 145], fill=(255, 255, 255), outline=BORDER_COLOR)
    days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    dx = 20
    for i, d in enumerate(days):
        is_sel = (i == 0)
        bg = PRIMARY_BLUE if is_sel else (241, 245, 249)
        tc = (255, 255, 255) if is_sel else TEXT_MED
        draw.rounded_rectangle([dx, 105, dx + 65, 135], radius=15, fill=bg)
        draw.text((dx + 32, 120), d[:3], fill=tc, font=font_small_bold, anchor="mm")
        dx += 74
        
    draw.text((20, 160), "Schedule for Monday", fill=TEXT_DARK, font=font_subtitle)
    draw.text((W - 90, 163), "4 Classes", fill=PRIMARY_BLUE, font=font_small_bold)
    
    slots = [
        ("09:00 AM", "10:00 AM", "CS501", "Design & Analysis of Algorithms", "Dr. Alan Turing", "Room 302 (Block A)", "Lecture", False),
        ("10:00 AM", "11:00 AM", "CS502", "Database Management Systems", "Prof. Edgar Codd", "Room 302 (Block A)", "Lecture", False),
        ("11:15 AM", "01:15 PM", "CS503L", "Computer Networks Lab", "Dr. Vint Cerf", "Networking Lab 2", "Lab", True),
        ("02:00 PM", "03:00 PM", "CS506", "Cloud Computing & DevOps", "Prof. Werner Vogels", "Room 205 (Block B)", "Lecture", False),
    ]
    
    ty = 190
    for t1, t2, code, name, inst, rm, typ, is_lab in slots:
        draw_card(draw, [20, ty, W - 20, ty + 105])
        
        # Time badge left column
        t_bg = (224, 242, 254) if not is_lab else (237, 233, 254)
        t_c = PRIMARY_BLUE if not is_lab else (124, 58, 237)
        draw.rounded_rectangle([32, ty + 12, 100, ty + 93], radius=10, fill=t_bg)
        draw.text((66, ty + 35), t1, fill=t_c, font=font_tiny, anchor="mm")
        draw.text((66, ty + 50), "to", fill=TEXT_LIGHT, font=font_tiny, anchor="mm")
        draw.text((66, ty + 65), t2, fill=t_c, font=font_tiny, anchor="mm")
        
        # Details
        draw.rounded_rectangle([115, ty + 12, 155, ty + 28], radius=4, fill=(241, 245, 249))
        draw.text((135, ty + 20), code, fill=TEXT_DARK, font=font_tiny, anchor="mm")
        
        draw.rounded_rectangle([W - 75, ty + 12, W - 32, ty + 28], radius=6, fill=PRIMARY_LIGHT)
        draw.text((W - 53, ty + 20), typ, fill=PRIMARY_DARK, font=font_tiny, anchor="mm")
        
        draw.text((115, ty + 38), name, fill=TEXT_DARK, font=font_body_bold)
        draw.text((115, ty + 60), f"Instructor: {inst}", fill=TEXT_MED, font=font_small)
        draw.text((115, ty + 80), f"Venue: {rm}", fill=PRIMARY_BLUE, font=font_small)
        
        ty += 118
        
    draw_bottom_nav(draw, active_index=2)
    img.save("assets/screenshots/timetable_screen.png")
    print("Generated timetable_screen.png")

# 4. ASSIGNMENTS SCREEN
def render_assignments():
    img, draw = create_base()
    
    # App Bar
    draw.rectangle([0, 40, W, 95], fill=(255, 255, 255), outline=BORDER_COLOR)
    draw.text((W/2, 67), "Assignments & Tasks", fill=TEXT_DARK, font=font_subtitle, anchor="mm")
    draw.ellipse([W - 46, 55, W - 22, 79], fill=PRIMARY_LIGHT)
    draw.text((W - 34, 67), "+", fill=PRIMARY_BLUE, font=font_subtitle, anchor="mm")
    
    # Filters
    draw.rectangle([0, 95, W, 145], fill=(255, 255, 255), outline=BORDER_COLOR)
    filters = [("All (5)", True), ("Pending (3)", False), ("Completed (2)", False)]
    fx = 20
    fw = (W - 40 - 16) / 3
    for label, is_sel in filters:
        bg = PRIMARY_BLUE if is_sel else (241, 245, 249)
        tc = (255, 255, 255) if is_sel else TEXT_MED
        draw.rounded_rectangle([fx, 105, fx + fw, 135], radius=10, fill=bg)
        draw.text((fx + fw/2, 120), label, fill=tc, font=font_small_bold, anchor="mm")
        fx += fw + 8
        
    tasks = [
        ("Design & Analysis of Algorithms", "Implement Dijkstra & Bellman-Ford", "Write clean C++/Python code to find shortest paths...", "Nov 18, 2026", False),
        ("Database Management Systems", "Relational Schema Normalization (3NF)", "Decompose the unnormalized hospital management db...", "Nov 20, 2026", False),
        ("Computer Networks", "Socket Programming Client-Server Chat", "Build multi-client TCP chat server using socket API...", "Nov 14, 2026", True),
        ("Software Engineering", "Agile Sprint Planning & SRS Document", "Formulate complete SRS specification with user stories...", "Nov 25, 2026", False),
        ("Artificial Intelligence", "Minimax Algorithm with Alpha-Beta", "Implement adversarial search for Tic-Tac-Toe engine...", "Nov 10, 2026", True),
    ]
    
    asy = 160
    for subj, title, desc, due, done in tasks:
        draw_card(draw, [20, asy, W - 20, asy + 112])
        draw.rounded_rectangle([32, asy + 10, 160, asy + 26], radius=4, fill=PRIMARY_LIGHT)
        draw.text((96, asy + 18), subj[:22], fill=PRIMARY_DARK, font=font_tiny, anchor="mm")
        
        status_bg = SUCCESS_BG if done else WARN_BG
        status_c = SUCCESS_TEXT if done else WARN_TEXT
        status_txt = "Completed" if done else "Pending"
        draw.rounded_rectangle([W - 90, asy + 10, W - 32, asy + 26], radius=6, fill=status_bg)
        draw.text((W - 61, asy + 18), status_txt, fill=status_c, font=font_tiny, anchor="mm")
        
        draw.text((32, asy + 36), title, fill=TEXT_DARK, font=font_body_bold)
        draw.text((32, asy + 56), desc, fill=TEXT_MED, font=font_small)
        draw.line([32, asy + 78, W - 32, asy + 78], fill=(241, 245, 249), width=1)
        
        draw.text((32, asy + 90), f"Due: {due}", fill=DANGER_TEXT, font=font_small_bold)
        
        # Checkbox Done
        cb_bg = PRIMARY_BLUE if done else (241, 245, 249)
        draw.rounded_rectangle([W - 100, asy + 86, W - 32, asy + 104], radius=6, fill=cb_bg)
        draw.text((W - 66, asy + 95), "✓ Done" if done else "Mark Done", fill=(255, 255, 255) if done else TEXT_MED, font=font_tiny, anchor="mm")
        
        asy += 122
        
    draw_bottom_nav(draw, active_index=3)
    img.save("assets/screenshots/assignments_screen.png")
    print("Generated assignments_screen.png")

# 5. STUDY MATERIALS SCREEN
def render_study_materials():
    img, draw = create_base()
    
    # App Bar
    draw.rectangle([0, 40, W, 95], fill=(255, 255, 255), outline=BORDER_COLOR)
    draw.text((W/2, 67), "Study Materials & Notes", fill=TEXT_DARK, font=font_subtitle, anchor="mm")
    
    # Search Box
    draw_card(draw, [20, 110, W - 20, 150], fill=(248, 250, 252), outline=BORDER_COLOR)
    draw.text((40, 130), "🔍 Search notes, subjects, or topics...", fill=TEXT_LIGHT, font=font_small, anchor="lm")
    
    # Subject Filter Chips
    chips = ["All", "Algorithms", "DBMS", "Networks", "AI", "Cloud"]
    cx = 20
    for i, ch in enumerate(chips):
        is_sel = (i == 0)
        draw.rounded_rectangle([cx, 160, cx + 55, 186], radius=13, fill=PRIMARY_BLUE if is_sel else (241, 245, 249))
        draw.text((cx + 27, 173), ch, fill=(255, 255, 255) if is_sel else TEXT_MED, font=font_tiny, anchor="mm")
        cx += 62
        
    materials = [
        ("Unit 1: Dynamic Programming & Greedy", "Design & Analysis of Algorithms", "4.8 MB", "Nov 02, 2026"),
        ("Unit 2: SQL Joins, Triggers & ACID", "Database Management Systems", "6.2 MB", "Oct 28, 2026"),
        ("OSI 7-Layer Model & TCP/IP Suite", "Computer Networks", "3.5 MB", "Oct 20, 2026"),
        ("Design Patterns & Clean Architecture", "Software Engineering", "5.1 MB", "Nov 05, 2026"),
        ("Heuristic Search & Knowledge Base", "Artificial Intelligence", "7.4 MB", "Oct 15, 2026"),
        ("Docker & Kubernetes Orchestration", "Cloud Computing & DevOps", "8.0 MB", "Nov 08, 2026"),
    ]
    
    my = 205
    for title, subj, size, dt in materials:
        draw_card(draw, [20, my, W - 20, my + 94])
        
        # PDF badge icon
        draw.rounded_rectangle([32, my + 14, 68, my + 54], radius=8, fill=(254, 226, 226))
        draw.text((50, my + 34), "PDF", fill=DANGER_TEXT, font=font_small_bold, anchor="mm")
        
        draw.text((80, my + 14), title, fill=TEXT_DARK, font=font_body_bold)
        draw.text((80, my + 34), subj, fill=PRIMARY_BLUE, font=font_small)
        draw.text((80, my + 52), f"{size}  •  Added: {dt}", fill=TEXT_LIGHT, font=font_tiny)
        
        draw.line([32, my + 68, W - 32, my + 68], fill=(241, 245, 249), width=1)
        
        draw.text((W - 130, my + 80), "👁 View Notes", fill=PRIMARY_BLUE, font=font_tiny)
        draw.rounded_rectangle([W - 75, my + 72, W - 32, my + 88], radius=6, fill=PRIMARY_BLUE)
        draw.text((W - 53, my + 80), "Download", fill=(255, 255, 255), font=font_tiny, anchor="mm")
        
        my += 105
        
    draw_bottom_nav(draw, active_index=0)
    img.save("assets/screenshots/study_materials_screen.png")
    print("Generated study_materials_screen.png")

# 6. RESULTS SCREEN
def render_results():
    img, draw = create_base()
    
    # App Bar
    draw.rectangle([0, 40, W, 95], fill=(255, 255, 255), outline=BORDER_COLOR)
    draw.text((W/2, 67), "Examination Results", fill=TEXT_DARK, font=font_subtitle, anchor="mm")
    
    # Semester selector dropdown
    draw_card(draw, [20, 110, W - 20, 150])
    draw.text((36, 130), "Select Semester:", fill=TEXT_DARK, font=font_body_bold, anchor="lm")
    draw.text((W - 80, 130), "Semester 5 ▼", fill=PRIMARY_BLUE, font=font_body_bold, anchor="lm")
    
    # Hero Score Banner
    draw.rounded_rectangle([20, 165, W - 20, 290], radius=18, fill=PRIMARY_BLUE)
    draw.text((36, 180), "SEMESTER RESULT", fill=(227, 242, 253), font=font_tiny)
    draw.text((36, 198), "Semester 5 Academic Performance", fill=(255, 255, 255), font=font_subtitle)
    
    draw.rounded_rectangle([W - 95, 180, W - 36, 204], radius=12, fill=SUCCESS_TEXT)
    draw.text((W - 65, 192), "✓ PASSED", fill=(255, 255, 255), font=font_tiny, anchor="mm")
    
    draw.rounded_rectangle([36, 230, W - 36, 274], radius=10, fill=(255, 255, 255, 40))
    col_w = (W - 72) / 3
    draw.text((36 + col_w * 0.5, 242), "SGPA", fill=(227, 242, 253), font=font_tiny, anchor="mm")
    draw.text((36 + col_w * 0.5, 258), "8.82 / 10.0", fill=(255, 255, 255), font=font_small_bold, anchor="mm")
    
    draw.text((36 + col_w * 1.5, 242), "Percentage", fill=(227, 242, 253), font=font_tiny, anchor="mm")
    draw.text((36 + col_w * 1.5, 258), "87.5%", fill=(255, 255, 255), font=font_small_bold, anchor="mm")
    
    draw.text((36 + col_w * 2.5, 242), "Total Marks", fill=(227, 242, 253), font=font_tiny, anchor="mm")
    draw.text((36 + col_w * 2.5, 258), "525 / 600", fill=(255, 255, 255), font=font_small_bold, anchor="mm")
    
    draw.text((20, 310), "Subject-wise Marks & Grades", fill=TEXT_DARK, font=font_subtitle)
    draw.text((W - 105, 313), "Download Memo >", fill=PRIMARY_BLUE, font=font_small_bold)
    
    subjects = [
        ("CS501", "Design & Analysis of Algorithms", "28", "62", "90", "A+", "9.0", 4),
        ("CS502", "Database Management Systems", "29", "64", "93", "O", "10.0", 4),
        ("CS503", "Computer Networks", "26", "58", "84", "A", "8.0", 3),
        ("CS504", "Software Engineering", "27", "60", "87", "A+", "9.0", 3),
        ("CS505", "Artificial Intelligence", "28", "61", "89", "A+", "9.0", 4),
    ]
    
    ry = 335
    for code, name, int_m, ext_m, tot_m, grd, gp, cr in subjects:
        draw_card(draw, [20, ry, W - 20, ry + 88])
        draw.rounded_rectangle([32, ry + 10, 75, ry + 26], radius=4, fill=PRIMARY_LIGHT)
        draw.text((53, ry + 18), code, fill=PRIMARY_DARK, font=font_tiny, anchor="mm")
        
        draw.text((85, ry + 12), name, fill=TEXT_DARK, font=font_body_bold)
        
        draw.rounded_rectangle([W - 65, ry + 10, W - 32, ry + 28], radius=6, fill=PRIMARY_LIGHT)
        draw.text((W - 48, ry + 19), grd, fill=PRIMARY_DARK, font=font_small_bold, anchor="mm")
        
        draw.line([32, ry + 40, W - 32, ry + 40], fill=(241, 245, 249), width=1)
        
        mc_w = (W - 64) / 4
        labels = [f"Internal: {int_m}", f"External: {ext_m}", f"Total: {tot_m}/100", f"Points: {gp}"]
        for idx, lbl in enumerate(labels):
            is_tot = (idx == 2)
            c = PRIMARY_BLUE if is_tot else TEXT_MED
            f = font_small_bold if is_tot else font_small
            draw.text((32 + idx * mc_w + mc_w/2, ry + 62), lbl, fill=c, font=f, anchor="mm")
            
        ry += 98
        
    draw_bottom_nav(draw, active_index=0)
    img.save("assets/screenshots/results_screen.png")
    print("Generated results_screen.png")

# 7. PROFILE SCREEN
def render_profile():
    img, draw = create_base()
    
    # App Bar
    draw.rectangle([0, 40, W, 95], fill=(255, 255, 255), outline=BORDER_COLOR)
    draw.text((W/2, 67), "Student Profile", fill=TEXT_DARK, font=font_subtitle, anchor="mm")
    draw.text((W - 45, 67), "Edit", fill=PRIMARY_BLUE, font=font_small_bold, anchor="mm")
    
    # Profile Card
    draw_card(draw, [20, 110, W - 20, 275])
    draw.ellipse([W/2 - 38, 125, W/2 + 38, 201], fill=PRIMARY_LIGHT)
    draw.ellipse([W/2 - 18, 140, W/2 + 18, 176], fill=PRIMARY_BLUE)
    draw.text((W/2, 214), "Alex Johnson", fill=TEXT_DARK, font=font_subtitle, anchor="mm")
    draw.text((W/2, 232), "Roll No: 21CS1045", fill=PRIMARY_BLUE, font=font_small_bold, anchor="mm")
    draw.text((W/2, 248), "Computer Science & Engineering", fill=TEXT_MED, font=font_small, anchor="mm")
    
    # Academic Info
    draw.text((20, 295), "Academic Details", fill=TEXT_DARK, font=font_subtitle)
    draw_card(draw, [20, 320, W - 20, 490])
    
    acad = [
        ("Program", "B.Tech Computer Science"),
        ("Department", "Computer Science & Engineering"),
        ("Semester", "Semester 5"),
        ("Academic Year", "2026 - 2027"),
        ("Student Portal ID", "STD-2026-8842"),
    ]
    py = 330
    for k, v in acad:
        draw.text((36, py), k, fill=TEXT_LIGHT, font=font_small)
        draw.text((36, py + 16), v, fill=TEXT_DARK, font=font_body_bold)
        draw.line([36, py + 33, W - 36, py + 33], fill=(241, 245, 249), width=1)
        py += 34
        
    # Contact Info
    draw.text((20, 510), "Contact Information", fill=TEXT_DARK, font=font_subtitle)
    draw_card(draw, [20, 535, W - 20, 640])
    contact = [
        ("University Email", "alex.johnson@studenthub.edu"),
        ("Phone Number", "+1 (555) 234-5678"),
        ("Campus Hostel", "Hostel Block 3, Room 412"),
    ]
    cy = 545
    for k, v in contact:
        draw.text((36, cy), k, fill=TEXT_LIGHT, font=font_small)
        draw.text((36, cy + 16), v, fill=TEXT_DARK, font=font_body_bold)
        draw.line([36, cy + 33, W - 36, cy + 33], fill=(241, 245, 249), width=1)
        cy += 34
        
    # Logout button
    draw_card(draw, [20, 660, W - 20, 715], fill=(254, 242, 242), outline=(254, 202, 202))
    draw.text((W/2, 687), "Sign Out from Device", fill=DANGER_TEXT, font=font_body_bold, anchor="mm")
    
    draw_bottom_nav(draw, active_index=4)
    img.save("assets/screenshots/profile_screen.png")
    print("Generated profile_screen.png")

# 8. LOGIN SCREEN
def render_login():
    img, draw = create_base()
    
    # App Logo
    draw.rounded_rectangle([W/2 - 42, 110, W/2 + 42, 194], radius=22, fill=PRIMARY_BLUE)
    draw.ellipse([W/2 - 20, 130, W/2 + 20, 170], outline=(255, 255, 255), width=3)
    
    draw.text((W/2, 220), "Student Hub", fill=PRIMARY_DARK, font=font_large, anchor="mm")
    draw.text((W/2, 245), "Sign in to access your student portal", fill=TEXT_MED, font=font_small, anchor="mm")
    
    # Inputs
    draw.text((36, 290), "Student ID or Email", fill=TEXT_DARK, font=font_body_bold)
    draw_card(draw, [36, 310, W - 36, 355], fill=(248, 250, 252))
    draw.text((50, 332), "alex.johnson@studenthub.edu", fill=TEXT_DARK, font=font_body, anchor="lm")
    
    draw.text((36, 375), "Password", fill=TEXT_DARK, font=font_body_bold)
    draw_card(draw, [36, 395, W - 36, 440], fill=(248, 250, 252))
    draw.text((50, 417), "••••••••••••", fill=TEXT_DARK, font=font_body, anchor="lm")
    draw.text((W - 75, 417), "👁", fill=TEXT_LIGHT, font=font_small, anchor="lm")
    
    draw.text((W - 36, 460), "Forgot Password?", fill=PRIMARY_BLUE, font=font_small_bold, anchor="rm")
    
    # Sign In Button
    draw.rounded_rectangle([36, 495, W - 36, 545], radius=12, fill=PRIMARY_BLUE)
    draw.text((W/2, 520), "Sign In", fill=(255, 255, 255), font=font_body_bold, anchor="mm")
    
    # Quick fill demo button
    draw.rounded_rectangle([36, 560, W - 36, 610], radius=12, fill=(255, 255, 255), outline=PRIMARY_BLUE)
    draw.text((W/2, 585), "⚡ Quick Fill Demo Account", fill=PRIMARY_BLUE, font=font_body_bold, anchor="mm")
    
    draw.text((W/2, 650), "Don't have an account? Register Here", fill=TEXT_MED, font=font_small, anchor="mm")
    
    img.save("assets/screenshots/login_screen.png")
    print("Generated login_screen.png")

if __name__ == "__main__":
    os.makedirs("assets/screenshots", exist_ok=True)
    render_home()
    render_attendance()
    render_timetable()
    render_assignments()
    render_study_materials()
    render_results()
    render_profile()
    render_login()
    print("All 8 screenshots generated successfully!")
